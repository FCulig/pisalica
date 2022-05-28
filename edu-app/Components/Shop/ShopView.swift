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
    private let isTablet = UIDevice.current.localizedModel == "iPad"

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
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    shopItemsPanel
                    Spacer()
                }
                Spacer()
            }
            coinsBalance
            backButton
        }
    }

    var backButton: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    AppImage.previousButton.image
                        .aspectRatio(contentMode: .fit)
                }
                .frame(height: 70, alignment: .top)
                .padding(.top, 15)
                .padding(.leading, isTablet ? 15 : 0)

                Spacer()
            }
            Spacer()
        }
    }

    var coinsBalance: some View {
        HStack {
            Spacer()
            VStack {
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
    }

    var shopItemsPanel: some View {
        ZStack {
            ZStack {
                AppImage.panelBackgroundImage.image

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
                            .frame(width: 120)
                            .onTapGesture {
                                viewModel.didTapItem(item)
                            }
                        }
                    }
                }
                .padding(.vertical, 50)
                .padding(.horizontal, 25)
            }
            .padding(.top, 35)
            .padding(.bottom, 15)
            .padding(.leading, 70)
            .padding(.trailing, 25)
        }
        .padding(.top, 20)
        .padding(.leading, 20)
        .padding(.trailing, 70)
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
