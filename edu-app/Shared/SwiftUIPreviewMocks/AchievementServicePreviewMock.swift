//
//  AchievementServicePreviewMock.swift
//  edu-app
//
//  Created by Filip Culig on 27.05.2022..
//

import CoreData

// MARK: - AchievementServicePreviewMock -

class AchievementServicePreviewMock: AchievementServiceful {
    var achievements: [Achievement] {
        []
    }

    func getAchievements(context _: NSManagedObjectContext) -> [Achievement] {
        print("Dohvacanje achievementa")
        return []
    }

    func updateAchievementProgress(achievementKey _: String, valueToBeAdded _: Int, context _: NSManagedObjectContext) {
        print("Updateanje achievementa")
    }
}
