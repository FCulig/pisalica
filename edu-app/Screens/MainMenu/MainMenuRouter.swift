//
//  MainMenuRouter.swift
//  edu-app
//
//  Created by Filip Čulig on 08.07.2024..
//

import SwiftUI

// MARK: - MainMenuRoute -
enum MainMenuRoute: Route {
    case achievements
    case mainMenu
    case shop
    case writingLettersLevelSelect
    case writingWordsLevel
}

// MARK: - MainMenuRouter -
final class MainMenuRouter: Router {
    // MARK: - File private properties -
    
    @Published fileprivate var route: MainMenuRoute = .mainMenu
    
    // MARK: - Private properties -
    
    private let strokeManager = StrokeManager()
    private let context = DataController().container.viewContext
    private lazy var levelService = LevelService(context: context)
    private lazy var achievementService = AchievementService(context: context)
    private lazy var shopService = ShopService(context: context, achievementService: achievementService)
    
    // MARK: - View for -
    
    @ViewBuilder fileprivate func view(for route: MainMenuRoute) -> some View {
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
}

// MARK: - Views -
    
private extension MainMenuRouter {
    var mainMenu: MainMenuView {
        let settingsService = SettingsService()
        let mainMenuViewModel = MainMenuViewModel(achievementService: achievementService,
                                                  levelService: levelService,
                                                  shopService: shopService,
                                                  settingsService: settingsService,
                                                  strokeManager: strokeManager)
        
        let routeEventPublisher = mainMenuViewModel.event.compactMap { $0 as? MainMenuRoute }.eraseToAnyPublisher()
        subscribeToNavigationEvents(from: routeEventPublisher)
        
        return MainMenuView(viewModel: mainMenuViewModel)
    }
    
    var shop: ShopView {
        let shopViewModel = ShopViewModel(achievementService: achievementService,
                                          shopService: shopService)
        
        return ShopView(viewModel: shopViewModel)
    }
    
    var achievements: AchievementsView {
        AchievementsView(achievementService: achievementService)
    }
    
    var writingLettersLevelSelect: LevelSelectView {
        let viewModel = LevelSelectViewModel(achievementService: achievementService,
                                             levelService: levelService,
                                             shopService: shopService,
                                             strokeManager: strokeManager)
        
        return LevelSelectView(viewModel: viewModel)
    }
    
    var writingWordsLevel: WritingWordsView {
        let viewModel = WritingWordsViewModel(levelService: levelService,
                                              shopService: shopService,
                                              achievementService: achievementService,
                                              strokeManager: strokeManager)
        
        return WritingWordsView(viewModel: viewModel)
    }
}

// MARK: - MainMenuRouterView -
struct MainMenuRouterView: View {
    @StateObject var router = MainMenuRouter()
        
    var body: some View {
        NavigationStack(path: $router.path) {
            router.view(for: .mainMenu)
                .navigationDestination(for: MainMenuRoute.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(router)
    }
}
