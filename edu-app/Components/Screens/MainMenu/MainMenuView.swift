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
    @State var isShowingSettings: Bool = false

    // MARK: - Initializer -

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View components -

    var body: some View {
        NavigationView {
            if isTablet {
                foregroundContent
                    .background(
                        AppImage.houseBackgroundTabletImage.image
                            .scaledToFill()
                            .ignoresSafeArea()
                            .offset(x: 80, y: 0)
                    )
                    .onAppear {
                        viewModel.configureWordsLevel()
                    }
                    .navigationBarHidden(true)
            } else {
                foregroundContent
                    .background(
                        AppImage.houseBackgroundImage.image
                            .scaledToFill()
                            .ignoresSafeArea()
                    )
                    .onAppear {
                        viewModel.configureWordsLevel()
                    }
                    .navigationBarHidden(true)
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
                    playButtons
                }
                Spacer()
            }
            HStack {
                VStack {
                    settingsButton
                    Spacer()
                }
                Spacer()
                VStack {
                    shopAndAchievementsButtons
                    Spacer()
                }
            }
        }
        .overlay(settingsDialog)
        .onAppear { BackgroundMusicService.shared.start() }
    }

    var appLogo: some View {
        AppImage.appLogo.image
            .scaledToFit()
            .frame(width: 150)
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
        Button(action: { isShowingSettings = true },
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

    var settingsDialog: some View {
        ZStack {
            if isShowingSettings {
                Rectangle()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .foregroundColor(.black.opacity(0.85))
                    .onTapGesture {
                        isShowingSettings = false
                    }
                SettingsView(viewModel: .init(settingsService: viewModel.settingsService))
            }
        }
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
