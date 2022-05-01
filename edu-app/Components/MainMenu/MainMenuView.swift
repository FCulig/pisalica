//
//  MainMenuView.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

struct MainMenuView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var viewModel: ViewModel
    @State var isPlayActive = false
    @State var isShopActive = false

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
                            NavigationLink(destination: LevelSelectView(), isActive: $isPlayActive) {
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
