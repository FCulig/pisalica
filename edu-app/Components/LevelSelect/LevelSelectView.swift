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
                            LevelButton(level)
                        } else {
                            NavigationLink {
                                NavigationLazyView(WritingLevelView(level: level,
                                                                    levelService: viewModel.levelService,
                                                                    achievementService: viewModel.achievementService,
                                                                    shopService: viewModel.shopService))
                            } label: {
                                LevelButton(level)
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
            .padding(.top, 55)
            .padding(.bottom, 10)
            .padding(.leading, isTablet ? 80 : 60)
            .padding(.trailing, isTablet ? 80 : 110)

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
                    Button {
                        viewModel.previousPage()
                    } label: {
                        AppImage.previousButton.image
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.leading, isTablet ? 35 : 30)
                }
                Spacer()
                if viewModel.showNextPageButton {
                    Button {
                        viewModel.nextPage()
                    } label: {
                        AppImage.nextButton.image
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.trailing, isTablet ? 35 : 70)
                }
            }
            .frame(height: isTablet ? 100 : 70, alignment: .center)
        }
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
                .padding(.top, 15)
                .padding(.leading, isTablet ? 15 : 0)

                Spacer()
            }
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
                .padding(.top, 15)
                .padding(.trailing, isTablet ? 15 : 0)
                Spacer()
            }
        }
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
