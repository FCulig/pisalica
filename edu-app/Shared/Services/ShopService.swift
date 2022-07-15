//
//  CoinsService.swift
//  edu-app
//
//  Created by Filip Culig on 18.05.2022..
//

import CoreData

// MARK: - ShopServiceful -

protocol ShopServiceful {
    var balance: Int { get }

    func updateCoins(amountToBeAdded: Int)
    func getShopItems() -> [ShopItem]
    func selectOrBuyShopItem(with index: Int)
    func configureShopData()
}

// MARK: - CoinsService -

class ShopService: ShopServiceful {
    private let context: NSManagedObjectContext
    private let achievementService: AchievementServiceful

    // MARK: - Initializer

    public init(context: NSManagedObjectContext, achievementService: AchievementServiceful) {
        self.context = context
        self.achievementService = achievementService
    }
}

// MARK: - Public methods -

extension ShopService {
    var balance: Int {
        return UserDefaults.standard.integer(forKey: "coinsBalance")
    }

    func updateCoins(amountToBeAdded: Int) {
        UserDefaults.standard.set(balance + amountToBeAdded, forKey: "coinsBalance")
    }

    func getShopItems() -> [ShopItem] {
        let fetchRequest: NSFetchRequest<ShopItem> = ShopItem.fetchRequest()
        var items: [ShopItem] = []

        do {
            items = try context.fetch(fetchRequest)
        } catch { print(error) }

        return items
    }

    func selectOrBuyShopItem(with index: Int) {
        let fetchRequest: NSFetchRequest<ShopItem> = ShopItem.fetchRequest()

        do {
            let items = try context.fetch(fetchRequest)
            if items[index].isBought {
                items[index].isSelected = true

                items.enumerated().forEach { itemIndex, item in
                    guard index != itemIndex else { return }
                    item.isSelected = false
                }
            } else if balance >= items[index].price {
                items[index].isBought = true
                updateCoins(amountToBeAdded: -Int(items[index].price))
                achievementService.updateAchievementProgress(achievementKey: "1_bought_item", valueToBeAdded: 1)
                achievementService.updateAchievementProgress(achievementKey: "9_bought_item", valueToBeAdded: 1)
            }

            try context.save()
        } catch { print(error) }
    }

    func configureShopData() {
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
}
