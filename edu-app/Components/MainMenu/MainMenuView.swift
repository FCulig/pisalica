//
//  MainMenuView.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

// MARK: - MainMenuView -

struct MainMenuView: View {
    private let isTablet = UIDevice.current.localizedModel == "iPad"

    @ObservedObject var viewModel: ViewModel
    @State var isPlayWordsActive = false
    @State var isPlayLettersActive = false
    @State var isShopActive = false
    @State var isAchievementsActive = false

    // MARK: - Initializer -

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View components -

    var body: some View {
        NavigationView {
            ZStack {
                if isTablet {
                    foregroundContent
                        .background(
                            AppImage.houseBackgroundTabletImage.image
                                .scaledToFill()
                                .ignoresSafeArea()
                                .offset(x: 80, y: 0)
                        )
                        .navigationBarHidden(true)
                } else {
                    foregroundContent
                        .background(
                            AppImage.houseBackgroundImage.image
                                .scaledToFill()
                                .ignoresSafeArea()
                        )
                        .navigationBarHidden(true)
                }
            }
        }
        .statusBar(hidden: true)
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var foregroundContent: some View {
        ZStack {
            HStack {
                Spacer()
                VStack {
                    // Letters
                    NavigationLink(destination: LevelSelectView(achievementService: viewModel.achievementService,
                                                                levelService: viewModel.levelService,
                                                                shopService: viewModel.shopService),
                                   isActive: $isPlayLettersActive) {
                        Button {
                            viewModel.configureLevelData()
                            isPlayLettersActive = true
                        } label: {
                            AppImage.lettersButton.image
                                .scaledToFit()
                        }
                        .frame(height: 100)
                    }

                    // Words
                    //                        NavigationLink(destination: EmptyView(), isActive: $isPlayWordsActive) {
                    //                            Button {
                    //                                viewModel.configureLevelData(with: managedObjectContext)
                    //                                isPlayWordsActive = true
                    //                            } label: {
                    //                                AppImage.wordsButton.image
                    //                                    .scaledToFit()
                    //                            }
                    //                            .frame(height: 100)
                    //                        }
                }
                Spacer()
            }
            HStack {
                Spacer()
                VStack {
                    shopAndAchievementsButtons
                    Spacer()
                }
            }
        }
    }

    var shopAndAchievementsButtons: some View {
        HStack {
            NavigationLink(destination: ShopView(viewModel: .init(achievementService: viewModel.achievementService, shopService: viewModel.shopService)),
                           isActive: $isShopActive) {
                Button {
                    viewModel.configureShopData()
                    isShopActive = true
                } label: {
                    AppImage.shopButton.image
                        .scaledToFit()
                        .frame(width: 65)
                }
            }

            Spacer()
                .frame(width: 25)

            NavigationLink(destination: AchievementsView(achievementService: viewModel.achievementService), isActive: $isAchievementsActive) {
                Button {
                    viewModel.configureAchievementData()
                    isAchievementsActive = true
                } label: {
                    AppImage.achievementsButton.image
                        .scaledToFit()
                        .frame(width: 65)
                }
            }
        }
        .padding(.top, 15)
        .padding(.trailing, isTablet ? 15 : 0)
    }
}

// MARK: - Preview -

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(viewModel: .init(achievementService: AchievementServicePreviewMock(),
                                      levelService: LevelServicePreviewMock(),
                                      shopService: ShopServicePreviewMock()))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        MainMenuView(viewModel: .init(achievementService: AchievementServicePreviewMock(),
                                      levelService: LevelServicePreviewMock(),
                                      shopService: ShopServicePreviewMock()))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
