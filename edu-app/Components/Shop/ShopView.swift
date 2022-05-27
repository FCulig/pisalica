//
//  ShopView.swift
//  edu-app
//
//  Created by Filip Culig on 30.04.2022..
//

import SwiftUI

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
        ZStack {
            AppImage.houseBackgroundImage.image
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 3)
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
            .padding(.bottom, 50)
            .padding(.horizontal, 40)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
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

                Spacer()
            }
            .padding(.vertical, 45)
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
                .padding(.top, 45)
                Spacer()
            }
        }
        .ignoresSafeArea()
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
