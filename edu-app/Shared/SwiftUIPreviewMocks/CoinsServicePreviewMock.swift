//
//  CoinsServicePreviewMock.swift
//  edu-app
//
//  Created by Filip Culig on 27.05.2022..
//

// MARK: - ShopServicePreviewMock -

class ShopServicePreviewMock: ShopServiceful {
    var balance: Int {
        return 10
    }

    func updateCoins(amountToBeAdded _: Int) {
        print("Updating coins")
    }

    func getShopItems() -> [ShopItem] {
        return []
    }

    func selectOrBuyShopItem(with _: Int) {
        print("Selecting or buying an item")
    }
}
