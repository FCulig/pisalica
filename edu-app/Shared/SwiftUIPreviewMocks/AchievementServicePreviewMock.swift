//
//  AchievementServicePreviewMock.swift
//  edu-app
//
//  Created by Filip Culig on 27.05.2022..
//

// MARK: - AchievementServicePreviewMock -

final class AchievementServicePreviewMock: AchievementServiceful {
    var achievements: [Achievement] {
        []
    }

    func getAchievements() -> [Achievement] {
        print("Dohvacanje achievementa")
        return []
    }

    func updateAchievementProgress(achievementKey _: String, valueToBeAdded _: Int) {
        print("Updateanje achievementa")
    }

    func configureAchievementData() {
        print("Configuring achievement data")
    }
}
