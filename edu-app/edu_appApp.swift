//
//  edu_appApp.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

@main
struct edu_appApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        let context = dataController.container.viewContext
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
        
        return WindowGroup {
            ParentalGateDialogView {
                NavigationStack {
                    MainMenuView(viewModel: mainMenuViewModel)
                }
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
