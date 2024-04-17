//
//  MainMenuViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import Combine
import CoreData

// MARK: - MainMenuViewModel -

final class MainMenuViewModel: ObservableObject {
    // MARK: - Private properties -

    private let levelService: LevelServiceful
    private let shopService: ShopServiceful
    private let strokeManager: StrokeManager
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties -

    let achievementService: AchievementServiceful
    let settingsService: SettingsServiceful
    let writingWordsViewModel: WritingWordsViewModel
    let levelSelectViewModel: LevelSelectViewModel
    let shopViewModel: ShopViewModel
    @Published var isWordsLocked: Bool = true
    @Published var isDownloadingModel: Bool = false

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

    func configureLevelData() {
        configureCoinsBalance()
        configureShopData()
        configureAchievementData()

        levelService.configureLevelData()
        writingWordsViewModel.newLevel()
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

// MARK: - Private methods

private extension MainMenuViewModel {
    func setupSubscriptions() {
        strokeManager.isDownloadingModel
            .assignWeak(to: \.isDownloadingModel, on: self)
            .store(in: &cancellables)
    }
}
