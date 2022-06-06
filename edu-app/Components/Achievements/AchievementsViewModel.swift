//
//  AchievementsViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 07.05.2022..
//

import CoreData
import Foundation

// MARK: - AchievementsView.ViewModel -

extension AchievementsView {
    class ViewModel: ObservableObject {
        private let achievementService: AchievementServiceful
        @Published var achievements: [Achievement] = []

        // MARK: - Initializer -

        public init(achievementService: AchievementServiceful) {
            self.achievementService = achievementService
        }
    }
}

// MARK: - Public methods -

extension AchievementsView.ViewModel {
    func getAchievements() {
        achievements = achievementService.getAchievements()
    }
}
