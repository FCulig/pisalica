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
        @Published var coinsService: CoinsService
        @Published var shopItems: [ShopItem] = []

        // MARK: - Initializer -

        public init(coinsService: CoinsService) {
            self.coinsService = coinsService
        }
    }
}

// MARK: - Public methods -

extension ShopView.ViewModel {
    func getShopItems(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ShopItem> = ShopItem.fetchRequest()

        do {
            shopItems = try context.fetch(fetchRequest)
        } catch { print(error) }
    }

    func didTapItem(_ item: ShopItem, context: NSManagedObjectContext) {
        guard let index = shopItems.firstIndex(of: item), !shopItems[index].isSelected else { return }
        let fetchRequest: NSFetchRequest<ShopItem> = ShopItem.fetchRequest()

        do {
            let items = try context.fetch(fetchRequest)
            if items[index].isBought {
                items[index].isSelected = true

                items.enumerated().forEach { itemIndex, item in
                    guard index != itemIndex else { return }
                    item.isSelected = false
                }
            } else {
                items[index].isBought = true
            }

            try context.save()
        } catch { print(error) }

        getShopItems(context: context)
    }
}
