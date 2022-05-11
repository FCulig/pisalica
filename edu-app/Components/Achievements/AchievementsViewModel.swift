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
        @Published var achievements: [Achievement] = []
    }
}

extension AchievementsView.ViewModel {
    func getAchievements(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Achievement> = Achievement.fetchRequest()

        do {
            achievements = try context.fetch(fetchRequest)
        } catch { print(error) }
    }
}
