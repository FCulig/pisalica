//
//  LevelSelectView.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import SwiftUI

// MARK: - LevelSelectView -

struct LevelSelectView: View {
    private let isTablet = UIDevice.current.localizedModel == "iPad"

    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ViewModel
    @FetchRequest(sortDescriptors: []) var levels: FetchedResults<Level>

    // MARK: - Initializer -

    public init(achievementService: AchievementServiceful,
                levelService: LevelServiceful,
                shopService: ShopServiceful)
    {
        let wrappedViewModel = ViewModel(achievementService: achievementService,
                                         levelService: levelService,
                                         shopService: shopService)
        _viewModel = StateObject(wrappedValue: wrappedViewModel)
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
                    levelSelectPanel
                    Spacer()
                }
                Spacer()
            }
            coinsBalance
            backButton
        }
        .onAppear { BackgroundMusicService.shared.start() }
    }

    var levelSelectPanel: some View {
        ZStack {
            ZStack {
                AppImage.panelBackgroundImage.image

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: isTablet ? 55 : 15) {
                    ForEach(viewModel.displayedLevels, id: \.self) { level in
                        if level.isLocked {
                            Image(level.lockedImage ?? "")
                                .resizable()
                                .scaledToFit()
                                .frame(height: isTablet ? 115 : 75, alignment: .center)
                        } else {
                            NavigationLink {
                                NavigationLazyView(WritingLettersLevelView(level: level,
                                                                           levelService: viewModel.levelService,
                                                                           achievementService: viewModel.achievementService,
                                                                           shopService: viewModel.shopService))
                            } label: {
                                Image(level.unlockedImage ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: isTablet ? 115 : 75, alignment: .center)
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
            .padding(.top, isTablet ? 120 : 55)
            .padding(.bottom, 10)
            .padding(.horizontal, isTablet ? 130 : 130)

            pageControlButtons
                .padding(.vertical, 10)
                .padding(.top, isTablet ? 50 : 0)
        }
        .onLoad { viewModel.getPaginatedLevels() }
    }

    var pageControlButtons: some View {
        VStack {
            Spacer()
            HStack {
                if viewModel.showPreviousPageButton {
                    Button(action: { viewModel.previousPage() },
                           image: AppImage.previousButton.image)
                        .padding(.leading, isTablet ? 100 : 105)
                }
                Spacer()
                if viewModel.showNextPageButton {
                    Button(action: { viewModel.nextPage() },
                           image: AppImage.nextButton.image)
                        .padding(.trailing, isTablet ? 95 : 100)
                }
            }
            .frame(height: isTablet ? 100 : 70, alignment: .center)
        }
    }

    var backButton: some View {
        HStack {
            VStack(alignment: .leading) {
                Button(action: { dismiss() },
                       image: AppImage.previousButton.image)
                    .frame(height: 70, alignment: .top)
                    .padding(.top, 15)
                    .padding(.leading, isTablet ? 15 : 0)

                Spacer()
            }
            Spacer()
        }
        .padding(.vertical, isTablet ? 30 : 15)
    }

    // TODO: Make this open shop

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
        .padding(.vertical, isTablet ? 30 : 15)
    }
}

struct LevelSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectView(achievementService: AchievementServicePreviewMock(),
                        levelService: LevelServicePreviewMock(),
                        shopService: ShopServicePreviewMock())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        LevelSelectView(achievementService: AchievementServicePreviewMock(),
                        levelService: LevelServicePreviewMock(),
                        shopService: ShopServicePreviewMock())
            .previewDevice("iPad Air (5th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
