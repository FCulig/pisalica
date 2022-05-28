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
        let achievementService = AchievementService(context: context)
        let shopService = ShopService(context: context, achievementService: achievementService)
        let levelService = LevelService(context: context)

        let mainMenuViewModel = MainMenuView.ViewModel(achievementService: achievementService,
                                                       levelService: levelService,
                                                       shopService: shopService)
        return MainMenuView(viewModel: mainMenuViewModel)
    }
}
