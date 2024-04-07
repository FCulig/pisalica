//
//  MainMenuView.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import Combine
import SwiftUI

// MARK: - MainMenuView -

struct MainMenuView: View {
    @ObservedObject var viewModel: MainMenuViewModel
    @State var isPlayWordsActive = false
    @State var isPlayLettersActive = false
    @State var isShopActive = false
    @State var isAchievementsActive = false
    @State var isSettingsDialogVisible = false
    
    // MARK: - Initializer -
    
    public init(viewModel: MainMenuViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View components -
    
    var body: some View {
        NavigationView {
            Screen(shouldBlurBackground: false,
                   centerContent: AnyView(playButtons),
                   topLeftContent: AnyView(settingsButton),
                   topRightContent: AnyView(shopAndAchievementsButtons))
            .onAppear{ viewModel.onAppear() }
            .overlay(settingsDialog)
            .overlay(modelDownloading)
        }
        .statusBar(hidden: true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var playButtons: some View {
        HStack {
            // Letters
            NavigationLink(destination: NavigationLazyView(LevelSelectView(viewModel: viewModel.levelSelectViewModel)),
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
                NavigationLink(destination: NavigationLazyView(WritingWordsView(viewModel: viewModel.writingWordsViewModel)),
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
    
    var shopAndAchievementsButtons: some View {
        HStack {
            NavigationLink(destination: ShopView(viewModel: viewModel.shopViewModel),
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
    
// MARK: - Settings -

private extension MainMenuView {
    var settingsButton: some View {
        Button(action: { isSettingsDialogVisible = true },
               image: AppImage.settingsButton.image)
            .frame(width: 65)
            .padding(.top, 15)
            .padding(.leading, isTablet ? 15 : 0)
    }
    
    @ViewBuilder var settingsDialog: some View {
        if isSettingsDialogVisible {
            Dialog(onDismissDialog: { isSettingsDialogVisible = false }) {
                SettingsListView(viewModel: .init(settingsService: viewModel.settingsService))
            }
        }
    }
}

// MARK: - Model download overlay -

private extension MainMenuView {
    @ViewBuilder var modelDownloading: some View {
        if viewModel.isDownloadingModel {
            VStack(alignment: .center, spacing: 10) {
                AppImage.appLogo.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: isTablet ? 200 : 100)
                    .padding(.bottom, isTablet ? 100 : 50)
                
                Text("Dobro došli u pisanku!")
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, x: 3, y: 2)
                    .font(.system(size: isTablet ? 55 : 40).weight(.bold))
                
                Text("Pripremanje igre je u tijeku...")
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, x: 3, y: 2)
                    .font(.system(size: isTablet ? 35 : 20).weight(.bold))
                
                LottieView(viewModel: .init(animationFileName: "loading"))
                    .frame(width: 300, height: 100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.9))
        }
    }
}

// MARK: - Preview -

//struct MainMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMenuView(viewModel: .init(achievementService: AchievementServicePreviewMock(),
//                                      levelService: LevelServicePreviewMock(),
//                                      shopService: ShopServicePreviewMock(),
//                                      settingsService: SettingsServicePreviewMock()))
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDevice("iPhone 13 Pro Max")
//
//        MainMenuView(viewModel: .init(achievementService: AchievementServicePreviewMock(),
//                                      levelService: LevelServicePreviewMock(),
//                                      shopService: ShopServicePreviewMock(),
//                                      settingsService: SettingsServicePreviewMock()))
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDevice("iPad Air (5th generation)")
//    }
//}
