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

    func getAchievements(context: NSManagedObjectContext) -> [Achievement]
    func updateAchievementProgress(achievementKey: String, valueToBeAdded: Int, context: NSManagedObjectContext)
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
    func getAchievements(context: NSManagedObjectContext) -> [Achievement] {
        let fetchRequest: NSFetchRequest<Achievement> = Achievement.fetchRequest()

        do {
            achievements = try context.fetch(fetchRequest)
        } catch { print(error) }

        return achievements
    }

    func updateAchievementProgress(achievementKey: String, valueToBeAdded: Int, context: NSManagedObjectContext) {
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
}
