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
    @StateObject var viewModel: ViewModel
    @State var isPlayActive = false
    @State var isShopActive = false
    @State var isAchievementsActive = false

    // MARK: - View components -

    var body: some View {
        NavigationView {
            ZStack {
                AppImage.houseBackgroundImage.image
                    .ignoresSafeArea()
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        List {
                            NavigationLink(destination: LevelSelectView(achievementService: viewModel.achievementService), isActive: $isPlayActive) {
                                Button {
                                    viewModel.configureLevelData(with: managedObjectContext)
                                    isPlayActive = true
                                } label: {
                                    AppImage.playButton.image
                                        .scaledToFit()
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .frame(width: 200, height: 200, alignment: .center)
                        Spacer()
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

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        return MainMenuView(viewModel: .init())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
