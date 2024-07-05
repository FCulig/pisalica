//
//  AppRouter.swift
//  edu-app
//
//  Created by Filip Čulig on 03.07.2024..
//

import SwiftUI

// MARK: - AppRoute
enum AppRoute {
    case achievements
    case mainMenu
    case shop
    case writingLettersLevelSelect
    case writingWordsLevel
}

// MARK: - AppRouter
class AppRouter: ObservableObject {
    // MARK: - File private properties
    
    @Published fileprivate var route: AppRoute = .mainMenu
    @Published fileprivate var path: NavigationPath = NavigationPath()
    
    // MARK: - Private properties
    
    private let strokeManager = StrokeManager()
    private let context = DataController().container.viewContext
    private lazy var levelService = LevelService(context: context)
    private lazy var achievementService = AchievementService(context: context)
    private lazy var shopService = ShopService(context: context, achievementService: achievementService)
    
    // MARK: - Navigation controls
    
    func navigateTo(_ appRoute: AppRoute) {
        path.append(appRoute)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    // MARK: - View for
    
    @ViewBuilder fileprivate func view(for route: AppRoute) -> some View {
        switch route {
        case .mainMenu:
            mainMenu
        case .shop:
            shop
        case .achievements:
            achievements
        case .writingLettersLevelSelect:
            writingLettersLevelSelect
        case .writingWordsLevel:
            writingWordsLevel
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder fileprivate var mainMenu: MainMenuView {
        let settingsService = SettingsService()
        let mainMenuViewModel = MainMenuViewModel(achievementService: achievementService,
                                                  levelService: levelService,
                                                  shopService: shopService,
                                                  settingsService: settingsService,
                                                  strokeManager: strokeManager)
        
        MainMenuView(viewModel: mainMenuViewModel)
    }
    
    @ViewBuilder fileprivate var shop: ShopView {
        let shopViewModel = ShopViewModel(achievementService: achievementService,
                                          shopService: shopService)
        
        ShopView(viewModel: shopViewModel)
    }
    
    @ViewBuilder fileprivate var achievements: AchievementsView {
        AchievementsView(achievementService: achievementService)
    }
    
    @ViewBuilder fileprivate var writingLettersLevelSelect: LevelSelectView {
        let viewModel = LevelSelectViewModel(achievementService: achievementService,
                                             levelService: levelService,
                                             shopService: shopService,
                                             strokeManager: strokeManager)
        
        LevelSelectView(viewModel: viewModel)
    }
    
    @ViewBuilder fileprivate var writingWordsLevel: WritingWordsView {
        let viewModel = WritingWordsViewModel(levelService: levelService,
                                              shopService: shopService,
                                              achievementService: achievementService,
                                              strokeManager: strokeManager)
        
        WritingWordsView(viewModel: viewModel)
    }
}

// MARK: - AppRouterView
struct AppRouterView: View {
    @StateObject var router: AppRouter = AppRouter()
        
    var body: some View {
        NavigationStack(path: $router.path) {
            router.view(for: .mainMenu)
                .navigationDestination(for: AppRoute.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(router)
    }
}
