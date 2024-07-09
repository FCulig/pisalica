//
//  MainMenuViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import Combine
import CoreData

// MARK: - MainMenuViewModel -
final class MainMenuViewModel: ObservableObject, Routable {
    // MARK: - Private properties -

    private let levelService: LevelServiceful
    private let shopService: ShopServiceful
    private let strokeManager: StrokeManager
    private let eventSubject: PassthroughSubject<MainMenuRoute, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties -

    let achievementService: AchievementServiceful
    let settingsService: SettingsServiceful
    let writingWordsViewModel: WritingWordsViewModel
    let levelSelectViewModel: LevelSelectViewModel
    let shopViewModel: ShopViewModel
    @Published var isWordsLocked: Bool = true
    @Published var isDownloadingModel: Bool = false
    
    var event: AnyPublisher<any Route, Never> {
        eventSubject
            .compactMap { $0 as Route }
            .eraseToAnyPublisher()
    }

    // MARK: - Initializer -

    public init(achievementService: AchievementServiceful,
                levelService: LevelServiceful,
                shopService: ShopServiceful,
                settingsService: SettingsServiceful,
                strokeManager: StrokeManager) {
        self.achievementService = achievementService
        self.levelService = levelService
        self.shopService = shopService
        self.settingsService = settingsService
        self.strokeManager = strokeManager
        
        self.writingWordsViewModel = WritingWordsViewModel(levelService: levelService,
                                                           shopService: shopService,
                                                           achievementService: achievementService,
                                                           strokeManager: strokeManager)
        
        self.levelSelectViewModel = LevelSelectViewModel(achievementService: achievementService,
                                                         levelService: levelService,
                                                         shopService: shopService,
                                                         strokeManager: strokeManager)

        self.shopViewModel = ShopViewModel(achievementService: achievementService,
                                           shopService: shopService)
        
        configureWordsLevel()
        setupSubscriptions()
    }
}

// MARK: - Public methods -

extension MainMenuViewModel {
    func onAppear() {
        BackgroundMusicService.shared.start()
        strokeManager.downloadModel()
    }
    
    func openLetterLevelSelect() {
        configureLevelData()
        eventSubject.send(.writingLettersLevelSelect)
    }
    
    func playWritingWords() {
        configureLevelData()
        writingWordsViewModel.newLevel()
        eventSubject.send(.writingWordsLevel)
    }
    
    func openShop() {
        configureShopData()
        eventSubject.send(.shop)
    }
    
    func openAchievements() {
        configureAchievementData()
        eventSubject.send(.achievements)
    }
}

// MARK: - Private methods

private extension MainMenuViewModel {
    func setupSubscriptions() {
        strokeManager.isDownloadingModel
            .assignWeak(to: \.isDownloadingModel, on: self)
            .store(in: &cancellables)
    }
    
    func configureLevelData() {
        configureCoinsBalance()
        configureShopData()
        configureAchievementData()

        levelService.configureLevelData()
    }

    func configureShopData() {
        configureAchievementData()
        configureCoinsBalance()

        shopService.configureShopData()
    }

    func configureAchievementData() {
        achievementService.configureAchievementData()
    }

    func configureCoinsBalance() {
        let preloadedDataKey = "didPreloadCoinsBalance"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) != true {
            userDefaults.set(0, forKey: "coinsBalance")
            userDefaults.set(true, forKey: preloadedDataKey)
        }
    }

    func configureWordsLevel() {
        let preloadedDataKey = "didInitializeWords"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) != true {
            userDefaults.set(true, forKey: "isWordsLevelLocked")
            userDefaults.set(true, forKey: preloadedDataKey)
        } else if userDefaults.bool(forKey: preloadedDataKey) == true {
            isWordsLocked = userDefaults.bool(forKey: "isWordsLevelLocked")
        }
    }
}
