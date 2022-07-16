//
//  CoinsServicePreviewMock.swift
//  edu-app
//
//  Created by Filip Culig on 27.05.2022..
//

// MARK: - ShopServicePreviewMock -

final class ShopServicePreviewMock: ShopServiceful {
    var balance: Int {
        return 10
    }

    func updateCoins(amountToBeAdded _: Int) {
        print("Updating coins")
    }

    func getShopItems() -> [ShopItem] {
//        let shopItem = ShopItem()
//
//        shopItem.name = "Roza"
//        shopItem.hexColor = "#FF00FF"
//        shopItem.unboughtImage = "shop-item-pink"
//        shopItem.boughtImage = "shop-item-bought-pink"
//        shopItem.selectedImage = "shop-item-selected-pink"
//        shopItem.isBought = true
//        shopItem.isSelected = false
//        shopItem.price = Int64(15)

        return []
    }

    func selectOrBuyShopItem(with _: Int) {
        print("Selecting or buying an item")
    }

    func configureShopData() {
        print("Configuring shop data")
    }
}
