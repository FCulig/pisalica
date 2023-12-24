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
        if isTablet {
            foregroundContent
                .background(
                    AppImage.houseBackgroundTabletImage.image
                        .scaledToFill()
                        .ignoresSafeArea()
                        .offset(x: 80, y: 0)
                        .blur(radius: 3)
                )
                .navigationBarHidden(true)
        } else {
            foregroundContent
                .background(
                    AppImage.houseBackgroundImage.image
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .blur(radius: 3)
                )
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.bottom)
        }
    }

    var foregroundContent: some View {
        VStack {
            HStack {
                backButton
                
                Spacer()
                
                coinsBalance
            }
            
            Spacer()
            
            shopItemsPanel
            
            Spacer()
        }
    }

    var backButton: some View {
        Button(action: {
                   dismiss()
               },
               image: AppImage.previousButton.image)
            .frame(height: 70, alignment: .top)
            .padding(.top, 15)
            .padding(.leading, isTablet ? 15 : 0)
    }

    var coinsBalance: some View {
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
        .padding()
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
