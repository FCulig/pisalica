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
    @EnvironmentObject var router: AppRouter
    @State var isSettingsDialogVisible = false
    
    // MARK: - Initializer -
    
    public init(viewModel: MainMenuViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View components -
    
    var body: some View {
        Screen(shouldBlurBackground: false,
               centerContent: AnyView(playButtons),
               topLeftContent: AnyView(settingsButton),
               topRightContent: AnyView(shopAndAchievementsButtons))
        .onAppear{ viewModel.onAppear() }
        .overlay(settingsDialog)
        .overlay(modelDownloading)
    }
    
    var playButtons: some View {
        HStack {
            // Letters
            Button(action: {
                        viewModel.configureLevelData()
                        router.navigateTo(.writingWordsLevel)
                    },
                   image: AppImage.lettersButton.image)
            .frame(height: 100)
            .padding(.trailing, isTablet ? 40 : 25)
            
            // Words
            if viewModel.isWordsLocked {
                AppImage.wordsButtonLocked.image
                    .scaledToFit()
                    .frame(height: 100)
            } else {
                Button(action: {
                            viewModel.configureLevelData()
                            viewModel.writingWordsViewModel.newLevel()
                            router.navigateTo(.writingLettersLevelSelect)
                        },
                       image: AppImage.wordsButton.image)
                .frame(height: 100)
            }
        }
    }
    
    var shopAndAchievementsButtons: some View {
        HStack {
            Button(action: {
                        viewModel.configureShopData()
                        router.navigateTo(.shop)
                    },
                   image: AppImage.shopButton.image)
            .frame(width: 65)
            
            Spacer()
                .frame(width: 25)
            
            Button(action: {
                        viewModel.configureAchievementData()
                        router.navigateTo(.achievements)
                    },
                   image: AppImage.achievementsButton.image)
            .frame(width: 65)
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
