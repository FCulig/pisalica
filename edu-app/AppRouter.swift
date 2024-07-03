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
}

// MARK: - AppRouter
class AppRouter: ObservableObject {
    // MARK: - File private properties
    
    @Published fileprivate var route: AppRoute = .mainMenu
    @Published fileprivate var path: NavigationPath = NavigationPath()
    
    // MARK: - Private properties
    
    private let context = DataController().container.viewContext
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
            mainMenu()
        case .shop:
            shop()
        case .achievements:
            achievements()
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder fileprivate func mainMenu() -> MainMenuView {
        let levelService = LevelService(context: context)
        let settingsService = SettingsService()
        let strokeManager = StrokeManager()
        let mainMenuViewModel = MainMenuViewModel(achievementService: achievementService,
                                                  levelService: levelService,
                                                  shopService: shopService,
                                                  settingsService: settingsService,
                                                  strokeManager: strokeManager)
        
        MainMenuView(viewModel: mainMenuViewModel)
    }
    
    @ViewBuilder fileprivate func shop() -> ShopView {
        let shopViewModel = ShopViewModel(achievementService: achievementService,
                                          shopService: shopService)
        
        ShopView(viewModel: shopViewModel)
    }
    
    @ViewBuilder fileprivate func achievements() -> AchievementsView {
        AchievementsView(achievementService: achievementService)
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
