//
//  ShopViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 30.04.2022..
//

import CoreData
import SwiftUI

// MARK: - ShopViewViewModel -

extension ShopView {
    class ViewModel: ObservableObject {
        private let achievementService: AchievementServiceful
        @Published var shopService: ShopServiceful
        @Published var shopItems: [ShopItem] = []

        // MARK: - Initializer -

        public init(achievementService: AchievementServiceful, shopService: ShopServiceful) {
            self.achievementService = achievementService
            self.shopService = shopService
        }
    }
}

// MARK: - Public methods -

extension ShopView.ViewModel {
    func getShopItems() {
        shopItems = shopService.getShopItems()
    }

    func didTapItem(_ item: ShopItem) {
        guard let index = shopItems.firstIndex(of: item), !shopItems[index].isSelected else { return }

        shopService.selectOrBuyShopItem(with: index)

        getShopItems()
    }
}
