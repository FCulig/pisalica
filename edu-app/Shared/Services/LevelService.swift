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
    func configureLevelData()
}

// MARK: - LevelService -

class LevelService: LevelServiceful {
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
            levels[currentLevelIndex + 1].isLocked = false

            try context.save()
        } catch { print(error) }
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
                    levelCoreData.isLocked = levelCoreData.name == "A" ? false : true

                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
    }
}
