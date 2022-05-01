//
//  ShopItem.swift
//  edu-app
//
//  Created by Filip Culig on 30.04.2022..
//

import SwiftUI

// MARK: - ShopItemView -

struct ShopItemView: View {
    let item: ShopItem

    // MARK: - Initializer -

    public init(item: ShopItem) {
        self.item = item
    }

    // MARK: - View components -

    var body: some View {
        Image(item.unboughtImage ?? "")
            .resizable()
            .scaledToFit()
            .frame(width: 120)
    }
}

// MARK: - Preview -

struct ShopItem_Previews: PreviewProvider {
    static var previews: some View {
        ShopItemView(item: ShopItem())
    }
}
