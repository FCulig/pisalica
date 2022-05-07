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
    class ViewModel: ObservableObject {}
}

// MARK: - Public methods -

extension MainMenuView.ViewModel {
    func configureLevelData(with context: NSManagedObjectContext) {
        configureShopData(with: context)

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
                    levelCoreData.isLocked = levelCoreData.name == "A" ? false : true

                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
    }

    func configureShopData(with context: NSManagedObjectContext) {
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

                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
    }
}
