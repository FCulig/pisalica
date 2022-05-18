//
//  MainMenuView.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

// MARK: - MainMenuView -

struct MainMenuView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
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
                AppImage.houseBackgroundImage.image
                    .ignoresSafeArea()
                HStack {
                    Spacer()
                    VStack {
                        // Letters
                        NavigationLink(destination: LevelSelectView(achievementService: viewModel.achievementService, coinsService: viewModel.coinsService),
                                       isActive: $isPlayLettersActive) {
                            Button {
                                viewModel.configureLevelData(with: managedObjectContext)
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
                    .padding(.bottom, 50)
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
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }

    var shopAndAchievementsButtons: some View {
        HStack {
            NavigationLink(destination: ShopView(), isActive: $isShopActive) {
                Button {
                    viewModel.configureShopData(with: managedObjectContext)
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
                    viewModel.configureAchievementData(with: managedObjectContext)
                    isAchievementsActive = true
                } label: {
                    AppImage.achievementsButton.image
                        .scaledToFit()
                        .frame(width: 65)
                }
            }
        }
        .padding(.top, 20)
        .ignoresSafeArea()
    }
}

// MARK: - Preview -

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        return MainMenuView(viewModel: .init(achievementService: .init(), coinsService: .init(context: .init(.privateQueue))))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
