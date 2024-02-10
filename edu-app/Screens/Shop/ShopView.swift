//
//  ShopView.swift
//  edu-app
//
//  Created by Filip Culig on 30.04.2022..
//

import SwiftUI
import UIKit

// MARK: - ShopView -

struct ShopView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ViewModel

    // MARK: - Initializer -

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View components -

    var body: some View {
        Screen(shouldShowBackButton: true,
               centerContent: AnyView(shopItemsPanel),
               topRightContent: AnyView(coinsBalance))
        .ignoresSafeArea(edges: isTablet ? .all : [.top, .trailing, .bottom])
    }

    var coinsBalance: some View {
        VStack(spacing: 0) {
            ZStack {
                AppImage.coinsBalanceBackground.image
                    .scaledToFit()
                    .frame(height: 65)
                Text("\(viewModel.shopService.balance)")
                    .foregroundColor(.white)
                    .padding(.leading, 45)
                    .padding(.bottom, 5)
                    .font(.system(size: 25).weight(.bold))
            }
            .padding(.top, 15)
            .padding(.trailing, isTablet ? 15 : 0)
            
            Spacer()
        }
    }

    var shopItemsPanel: some View {
        Panel {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 25) {
                    ForEach(viewModel.shopItems, id: \.self) { item in
                        Group {
                            if item.isSelected {
                                Image(item.selectedImage ?? "")
                                    .resizable()
                            } else if item.isBought {
                                Image(item.boughtImage ?? "")
                                    .resizable()
                            } else {
                                Image(item.unboughtImage ?? "")
                                    .resizable()
                            }
                        }
                        .scaledToFit()
                        .frame(width: isTablet ? 180 : 120)
                        .onTapGesture {
                            viewModel.didTapItem(item)
                        }
                    }
                }
            }
        }
        .padding(.vertical, isTablet ? 100 : 0)
        .padding(.trailing, isTablet ? 0 : 55)
        .onLoad { viewModel.getShopItems() }
    }
}

// MARK: - Preview -

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(viewModel: .init(achievementService: AchievementServicePreviewMock(),
                                  shopService: ShopServicePreviewMock()))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        ShopView(viewModel: .init(achievementService: AchievementServicePreviewMock(),
                                  shopService: ShopServicePreviewMock()))
            .previewDevice("iPad Air (5th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
