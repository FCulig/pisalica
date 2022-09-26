//
//  LevelService.swift
//  edu-app
//
//  Created by Filip Culig on 13.05.2022..
//

import CoreData

// MARK: - LevelServiceful -

protocol LevelServiceful {
    var levels: [Level] { get set }

    func unlockLevelAfter(_ level: Level)
    func getLevels() -> [Level]
    func getLevelForName(_ name: String) -> Level?
    func getRandomWordLevel() -> Level
    func getLineColorCode() -> String
    func configureLevelData()
}

// MARK: - LevelService -

final class LevelService: LevelServiceful {
    // MARK: - Private properties -

    private let context: NSManagedObjectContext

    // MARK: - Public properties -

    public var levels: [Level] = []

    // MARK: - Initializer

    public init(context: NSManagedObjectContext) {
        self.context = context
    }
}

// MARK: - Public methods -

extension LevelService {
    func unlockLevelAfter(_ level: Level) {
        guard let currentLevelIndex = levels.firstIndex(of: level),
              currentLevelIndex < levels.count - 1 else { return }
        do {
            // Unlock words containing new letter
//            let words = levels.filter{$0.isWord == true }
            let unlockedLetters = levels.filter { $0.isWord == false }
                .filter { $0.isLocked == false }

            levels.forEach { level in
                guard level.isWord, level.isLocked else { return }

                // Tu su sve rijeci koje su zakljucane
                var areAllLettersUnlocked = true

                level.name?.forEach { character in
                    let letter = unlockedLetters.first { $0.name == character.description }
                    if letter == nil {
                        areAllLettersUnlocked = false
                    }
                }

                if areAllLettersUnlocked {
                    level.isLocked = false

                    let userDefaults = UserDefaults.standard
                    userDefaults.set(false, forKey: "isWordsLevelLocked")
                }
            }

            // Unlock next level
            levels[currentLevelIndex + 1].isLocked = false

            try context.save()
        } catch { print(error) }
    }

    func getLevels() -> [Level] {
        let fetchRequest: NSFetchRequest<Level> = Level.fetchRequest()
        var levels: [Level] = []

        do {
            levels = try context.fetch(fetchRequest)
        } catch { print(error) }

        return levels
    }

    func getLevelForName(_ name: String) -> Level? {
        let levels = getLevels()

        return levels.first { $0.name == name }
    }

    func getRandomWordLevel() -> Level {
        let levels = getLevels()
        let unlockedLevels = levels.filter { $0.isWord == true }
            .filter { $0.isLocked == false }

        return unlockedLevels[Int.random(in: 0 ..< unlockedLevels.count)]
    }

    func getLineColorCode() -> String {
        let fetchRequest: NSFetchRequest<ShopItem> = ShopItem.fetchRequest()
        var strokeColor = ""

        do {
            let shopItems = try context.fetch(fetchRequest)
            shopItems.forEach { item in
                guard item.isSelected else { return }
                strokeColor = item.hexColor ?? "#121212"
            }

        } catch { print(error) }

        return strokeColor
    }

    func configureLevelData() {
        let preloadedDataKey = "didPreloadLevelData"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) != true {
            do {
                guard let levelsUrlPath = Bundle.main.url(forResource: "Levels", withExtension: "json") else { return }

                let decoder = JSONDecoder()
                let data = try Data(contentsOf: levelsUrlPath)
                let jsonData = try decoder.decode([DecodableLevel].self, from: data)

                guard jsonData.count > 0 else { return }

                for level in jsonData {
                    let levelCoreData = Level(context: context)
                    levelCoreData.id = UUID()
                    levelCoreData.name = level.name
                    levelCoreData.numberOfLines = level.numberOfLines
                    levelCoreData.results = level.results
                    levelCoreData.lockedImage = level.lockedImage
                    levelCoreData.unlockedImage = level.unlockedImage
                    levelCoreData.guideImage = level.guideImage
                    levelCoreData.outlineImage = level.outlineImage
                    levelCoreData.wordImage = ""
                    levelCoreData.isWord = false
                    levelCoreData.isLocked = levelCoreData.name == "I" ? false : true

                    try! context.save()
                }

                guard let wordsUrlPath = Bundle.main.url(forResource: "Words", withExtension: "json") else { return }

                let wordData = try Data(contentsOf: wordsUrlPath)
                let wordJsonData = try decoder.decode([DecodableLevel].self, from: wordData)

                guard wordJsonData.count > 0 else { return }

                for level in wordJsonData {
                    let levelCoreData = Level(context: context)
                    levelCoreData.id = UUID()
                    levelCoreData.name = level.name
                    levelCoreData.outlineImage = level.outlineImage
                    levelCoreData.wordImage = level.wordImage
                    levelCoreData.isWord = true
                    levelCoreData.isLocked = true

                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
    }
}
