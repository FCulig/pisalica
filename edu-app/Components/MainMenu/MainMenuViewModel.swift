//
//  MainMenuViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import Combine
import CoreData
import Foundation

// MARK: - MainMenuViewModel -

extension MainMenuView {
    class ViewModel: ObservableObject {
        let achievementService: AchievementServiceful
        let shopService: ShopServiceful

        // MARK: - Initializer -

        public init(achievementService: AchievementServiceful, shopService: ShopServiceful) {
            self.achievementService = achievementService
            self.shopService = shopService
        }
    }
}

// MARK: - Public methods -

extension MainMenuView.ViewModel {
    func configureLevelData(with context: NSManagedObjectContext) {
        configureCoinsBalance()
        configureShopData(with: context)
        configureAchievementData(with: context)

        let preloadedDataKey = "didPreloadLevelData"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) != true {
            do {
                guard let levelsUrlPath = Bundle.main.url(forResource: "Levels", withExtension: "json") else { return }

                let decoder = JSONDecoder()
                let data = try Data(contentsOf: levelsUrlPath)
                let jsonData = try decoder.decode([DecodableLevel].self, from: data)

                guard jsonData.count > 0 else { return }

                for level in jsonData {
                    let levelCoreData = Level(context: context)
                    levelCoreData.id = UUID()
                    levelCoreData.name = level.name
                    levelCoreData.numberOfLines = level.numberOfLines
                    levelCoreData.results = level.results
                    levelCoreData.lockedImage = level.lockedImage
                    levelCoreData.unlockedImage = level.unlockedImage
                    levelCoreData.guideImage = level.guideImage
                    levelCoreData.outlineImage = level.outlineImage
                    levelCoreData.isLocked = levelCoreData.name == "A" ? false : true

                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
    }

    func configureShopData(with context: NSManagedObjectContext) {
        configureAchievementData(with: context)
        configureCoinsBalance()

        let preloadedDataKey = "didPreloadShopData"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) != true {
            do {
                guard let shopItemsUrlPath = Bundle.main.url(forResource: "ShopItems", withExtension: "json") else { return }

                let decoder = JSONDecoder()
                let data = try Data(contentsOf: shopItemsUrlPath)
                let jsonData = try decoder.decode([DecodableShopItem].self, from: data)

                guard jsonData.count > 0 else { return }

                for shopItem in jsonData {
                    let shopItemCoreData = ShopItem(context: context)
                    shopItemCoreData.id = UUID()
                    shopItemCoreData.name = shopItem.name
                    shopItemCoreData.hexColor = shopItem.hexColor
                    shopItemCoreData.unboughtImage = shopItem.unboughtImage
                    shopItemCoreData.boughtImage = shopItem.boughtImage
                    shopItemCoreData.selectedImage = shopItem.selectedImage
                    shopItemCoreData.isBought = shopItemCoreData.name == "Crna" ? true : false
                    shopItemCoreData.isSelected = shopItemCoreData.name == "Crna" ? true : false
                    shopItemCoreData.price = Int64(shopItem.price)

                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
    }

    func configureAchievementData(with context: NSManagedObjectContext) {
        let preloadedDataKey = "didPreloadAchievementData"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) != true {
            do {
                guard let achievementsUrlPath = Bundle.main.url(forResource: "Achievements", withExtension: "json") else { return }

                let decoder = JSONDecoder()
                let data = try Data(contentsOf: achievementsUrlPath)
                let jsonData = try decoder.decode([DecodableAchievementItem].self, from: data)

                guard jsonData.count > 0 else { return }

                for achievement in jsonData {
                    let achievementCoreData = Achievement(context: context)
                    achievementCoreData.id = UUID()
                    achievementCoreData.name = achievement.name
                    achievementCoreData.medalImage = achievement.medalImage
                    achievementCoreData.key = achievement.key
                    achievementCoreData.target = Int64(achievement.target)
                    achievementCoreData.currentValue = 0

                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
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
