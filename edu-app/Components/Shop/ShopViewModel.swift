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
        @Published var shopItems: [ShopItem] = []

        // MARK: - Initializer -
        
        public init() {}
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
}
