//
//  MainMenuViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import CoreData

// MARK: - MainMenuViewModel -

extension MainMenuView {
    class ViewModel: ObservableObject {
        let achievementService: AchievementServiceful
        let levelService: LevelServiceful
        let shopService: ShopServiceful

        // MARK: - Initializer -

        public init(achievementService: AchievementServiceful,
                    levelService: LevelServiceful,
                    shopService: ShopServiceful)
        {
            self.achievementService = achievementService
            self.levelService = levelService
            self.shopService = shopService
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
}
