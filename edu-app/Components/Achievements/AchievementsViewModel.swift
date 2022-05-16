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
        private let achievementService: AchievementService
        @Published var achievements: [Achievement] = []

        public init(achievementService: AchievementService) {
            self.achievementService = achievementService
        }
    }
}

extension AchievementsView.ViewModel {
    func getAchievements(context: NSManagedObjectContext) {
        achievements = achievementService.getAchievements(context: context)
    }
}