//
//  AchievementService.swift
//  edu-app
//
//  Created by Filip Culig on 14.05.2022..
//

import CoreData

// MARK: - AchievementServiceful -

protocol AchievementServiceful {
    var achievements: [Achievement] { get }

    func getAchievements() -> [Achievement]
    func updateAchievementProgress(achievementKey: String, valueToBeAdded: Int)
    func configureAchievementData()
}

// MARK: - AchievementService -

class AchievementService: AchievementServiceful {
    // MARK: - Private properties -

    private let context: NSManagedObjectContext

    // MARK: - Public properties -

    var achievements: [Achievement] = []

    // MARK: - Initializer

    public init(context: NSManagedObjectContext) {
        self.context = context
    }
}

// MARK: - Public methods -

extension AchievementService {
    func getAchievements() -> [Achievement] {
        let fetchRequest: NSFetchRequest<Achievement> = Achievement.fetchRequest()

        do {
            achievements = try context.fetch(fetchRequest)
        } catch { print(error) }

        return achievements
    }

    func updateAchievementProgress(achievementKey: String, valueToBeAdded: Int) {
        let achievements = getAchievements()
        guard let achievement = achievements.first(where: { $0.key == achievementKey }),
              achievement.currentValue < achievement.target else { return }

        do {
            if achievement.currentValue + Int64(valueToBeAdded) > achievement.target {
                achievement.currentValue = achievement.target
            } else {
                achievement.currentValue += Int64(valueToBeAdded)
            }

            try context.save()
        } catch { print(error) }
    }

    func configureAchievementData() {
        let preloadedDataKey = "didPreloadAchievementData"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) != true {
            do {
                guard let achievementsUrlPath = Bundle.main.url(forResource: "Achievements", withExtension: "json") else { return }

                let decoder = JSONDecoder()
                let data = try Data(contentsOf: achievementsUrlPath)
                let jsonData = try decoder.decode([DecodableAchievementItem].self, from: data)

                guard jsonData.count > 0 else { return }

                for achievement in jsonData {
                    let achievementCoreData = Achievement(context: context)
                    achievementCoreData.id = UUID()
                    achievementCoreData.name = achievement.name
                    achievementCoreData.medalImage = achievement.medalImage
                    achievementCoreData.key = achievement.key
                    achievementCoreData.target = Int64(achievement.target)
                    achievementCoreData.currentValue = 0

                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
    }
}
