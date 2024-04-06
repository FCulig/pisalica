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

final class AppCoordinator {
    // MARK: - Start -

    @MainActor func start(context: NSManagedObjectContext) -> some View {
        let achievementService = AchievementService(context: context)
        let levelService = LevelService(context: context)
        let shopService = ShopService(context: context, achievementService: achievementService)
        let settingsService = SettingsService()
        let strokeManager = StrokeManager()

        let mainMenuViewModel = MainMenuViewModel(achievementService: achievementService,
                                                  levelService: levelService,
                                                  shopService: shopService,
                                                  settingsService: settingsService,
                                                  strokeManager: strokeManager)

        return ParentalGateDialogView {
            MainMenuView(viewModel: mainMenuViewModel)
        }
    }
}
