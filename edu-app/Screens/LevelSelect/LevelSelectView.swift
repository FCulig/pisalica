//
//  LevelSelectView.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import SwiftUI

// MARK: - LevelSelectView -

struct LevelSelectView: View {
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

    // MARK: - Body -

    var body: some View {
        foregroundContent
            .background(background)
            .navigationBarHidden(true)
    }
    
    // MARK: - View components -

    var foregroundContent: some View {
        Screen(shouldShowBackButton: true,
               centerContent: AnyView(levelSelectPanel),
               topRightContent: AnyView(coinsBalance))
        .ignoresSafeArea(edges: isTablet ? .all : [.top, .trailing, .bottom])
        .onAppear { BackgroundMusicService.shared.start() }
    }

    var levelSelectPanel: some View {
        Panel {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: isTablet ? 55 : 15) {
                    ForEach(viewModel.levels, id: \.self) { level in
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
                .padding(.top, 20)
            }
        }
        .padding(.vertical, isTablet ? 100 : 0)
        .padding(.trailing, isTablet ? 0 : 55)
        .onLoad { viewModel.getLevels() }
    }

    // TODO: Make this open shop

    var coinsBalance: some View {
        VStack(spacing: 0) {
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
