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

    @Environment(\.isPresented) var isPresented

    @ObservedObject var viewModel: ViewModel
    @State var isPlayWordsActive = false
    @State var isPlayLettersActive = false
    @State var isShopActive = false
    @State var isAchievementsActive = false
    
    @State var settingsDialog: Dialog

    // MARK: - Initializer -

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        settingsDialog = Dialog(content: AnyView(SettingsView(viewModel: .init(settingsService: viewModel.settingsService))))
    }

    // MARK: - View components -

    var body: some View {
        NavigationView {
            Grid(shouldBlurBackground: false,
                 centerContent: AnyView(playButtons),
                 topLeftContent: AnyView(settingsButton),
                 topRightContent: AnyView(shopAndAchievementsButtons),
                 onAppear: {
                viewModel.onAppear()
            }
            )
            .overlay(settingsDialog)
        }
        .statusBar(hidden: true)
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var playButtons: some View {
        HStack {
            // Letters
            NavigationLink(destination: NavigationLazyView(LevelSelectView(achievementService: viewModel.achievementService,
                                                                           levelService: viewModel.levelService,
                                                                           shopService: viewModel.shopService)),
            isActive: $isPlayLettersActive) {
                Button(action: {
                           viewModel.configureLevelData()
                           isPlayLettersActive = true
                       },
                       image: AppImage.lettersButton.image)
                    .frame(height: 100)
                    .padding(.trailing, isTablet ? 40 : 25)
            }

            // Words
            if viewModel.isWordsLocked {
                AppImage.wordsButtonLocked.image
                    .scaledToFit()
                    .frame(height: 100)
            } else {
                NavigationLink(destination: NavigationLazyView(WritingWordsView(levelService: viewModel.levelService,
                                                                                shopService: viewModel.shopService,
                                                                                achievementService: viewModel.achievementService)),
                isActive: $isPlayWordsActive) {
                    Button(action: {
                        viewModel.configureLevelData()
                        isPlayWordsActive = true
                    }, image: AppImage.wordsButton.image)
                        .frame(height: 100)
                }
            }
        }
    }

    var settingsButton: some View {
        Button(action: { settingsDialog.show() },
               image: AppImage.settingsButton.image)
            .frame(width: 65)
            .padding(.top, 15)
            .padding(.leading, isTablet ? 15 : 0)
    }

    var shopAndAchievementsButtons: some View {
        HStack {
            NavigationLink(destination: ShopView(viewModel: .init(achievementService: viewModel.achievementService, shopService: viewModel.shopService)),
                           isActive: $isShopActive) {
                Button(action: {
                           viewModel.configureShopData()
                           isShopActive = true
                       },
                       image: AppImage.shopButton.image)
                    .frame(width: 65)
            }

            Spacer()
                .frame(width: 25)

            NavigationLink(destination: AchievementsView(achievementService: viewModel.achievementService), isActive: $isAchievementsActive) {
                Button(action: {
                           viewModel.configureAchievementData()
                           isAchievementsActive = true
                       },
                       image: AppImage.achievementsButton.image)
                    .frame(width: 65)
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
                                      shopService: ShopServicePreviewMock(),
                                      settingsService: SettingsServicePreviewMock()))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        MainMenuView(viewModel: .init(achievementService: AchievementServicePreviewMock(),
                                      levelService: LevelServicePreviewMock(),
                                      shopService: ShopServicePreviewMock(),
                                      settingsService: SettingsServicePreviewMock()))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
