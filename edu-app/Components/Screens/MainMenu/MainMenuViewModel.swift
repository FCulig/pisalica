//
//  MainMenuViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import CoreData

// MARK: - MainMenuViewModel -

extension MainMenuView {
    final class ViewModel: ObservableObject {
        // MARK: - Public properties -

        let achievementService: AchievementServiceful
        let levelService: LevelServiceful
        let shopService: ShopServiceful
        let settingsService: SettingsServiceful

        @Published var isWordsLocked: Bool = true

        // MARK: - Initializer -

        public init(achievementService: AchievementServiceful,
                    levelService: LevelServiceful,
                    shopService: ShopServiceful,
                    settingsService: SettingsServiceful)
        {
            self.achievementService = achievementService
            self.levelService = levelService
            self.shopService = shopService
            self.settingsService = settingsService

            configureWordsLevel()
        }
    }
}

// MARK: - Public methods -

extension MainMenuView.ViewModel {
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
