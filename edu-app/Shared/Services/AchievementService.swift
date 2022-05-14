//
//  AchievementService.swift
//  edu-app
//
//  Created by Filip Culig on 14.05.2022..
//

import CoreData

// MARK: - AchievementService -

class AchievementService {
    var achievements: [Achievement] = []

    public init() {}
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
