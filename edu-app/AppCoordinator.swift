//
//  AppCoordinator.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import Combine
import CoreData
import SwiftUI

// MARK: - AppCoordinator -

class AppCoordinator {
    // MARK: - Start -

    @MainActor func start(context: NSManagedObjectContext) -> some View {
        let achievementService = AchievementService()
        let coinsService = CoinsService(context: context)

        let mainMenuViewModel = MainMenuView.ViewModel(achievementService: achievementService,
                                                       coinsService: coinsService)
        return MainMenuView(viewModel: mainMenuViewModel)
    }
}
