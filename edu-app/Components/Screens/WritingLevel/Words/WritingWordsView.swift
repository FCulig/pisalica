//
//  WritingWordsView.swift
//  edu-app
//
//  Created by Filip Culig on 04.06.2022..
//

import SwiftUI

// MARK: - WritingWordsView -

struct WritingWordsView: View {
    // MARK: - Private properties -

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ViewModel
    private let isTablet = UIDevice.current.localizedModel == "iPad"

    // MARK: - Initializer -

    public init(levelService: LevelServiceful,
                shopService: ShopServiceful,
                achievementService: AchievementServiceful)
    {
        let wrappedViewModel = ViewModel(levelService: levelService,
                                         shopService: shopService,
                                         achievementService: achievementService)
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
            drawingCanvasContainer
            buttons
        }
        .onAppear {
            BackgroundMusicService.shared.pause()
            viewModel.drawingCanvasViewModel.configureLineColor()
        }
    }

    var drawingCanvasContainer: some View {
        ZStack {
            AppImage.drawingPanelBackgroundImage.image
            Image(viewModel.drawingCanvasViewModel.level.wordImage ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: isTablet ? 200 : 100)
                .padding(.bottom, isTablet ? 270 : 100)
            drawingCanvas
        }
        .padding(.top, 70)
        .padding(.bottom, 10)
        .padding(.horizontal, 130)
    }

    var drawingCanvas: some View {
        ZStack {
            letterPlaceholders
                .padding(.top, isTablet ? 300 : 200)
            DrawingCanvasView(viewModel: viewModel.drawingCanvasViewModel)
                .padding(.leading, isTablet ? 69 : 44)
                .padding(.trailing, isTablet ? 65 : 40)
                .padding(.top, isTablet ? 59 : 27)
                .padding(.bottom, isTablet ? 75 : 34)
        }
    }

    var letterPlaceholders: some View {
        HStack {
            ForEach(0 ..< viewModel.wordName.count, id: \.self) { i in
                VStack {
                    if viewModel.visibleHints[i] == true {
                        Text(viewModel.wordName[i])
                            .foregroundColor(.black)
                            .font(.system(size: isTablet ? 100 : 50).weight(.bold))
                            .padding(.bottom, isTablet ? -20 : -10)
                    } else {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: isTablet ? 85 : 55, height: isTablet ? 100 : 51)
                    }

                    Rectangle()
                        .frame(width: isTablet ? 90 : 55, height: 10)
                        .foregroundColor(.black)
                }
                .padding(.trailing, isTablet ? 0 : 10)
            }
        }
    }

    var buttons: some View {
        HStack {
            VStack(alignment: .leading) {
                Button(action: { dismiss() },
                       image: AppImage.previousButton.image)
                    .frame(height: 70, alignment: .top)
                Spacer()
            }
            Spacer()
            VStack(alignment: .trailing) {
                if isTablet {
                    coinsBalance
                        .padding(.trailing, -10)
                        .blink(on: $viewModel.shouldHighlightCoinsBalance, repeatCount: 4, duration: 0.5)
                } else {
                    coinsBalance
                        .padding(.trailing, -10)
                }

                // TODO: Make it better

                SwiftUI.Button {
                    viewModel.buyNewHint()
                } label: {
                    if viewModel.canBuyHint {
                        AppImage.hintButton.image
                            .scaledToFit()
                            .frame(height: 70, alignment: .top)
                    } else {
                        AppImage.hintButtonLocked.image
                            .scaledToFit()
                            .frame(height: 70, alignment: .top)
                    }
                }

                Spacer()
            }
        }
        .padding(.vertical, isTablet ? 30 : 15)
        .padding(.leading, isTablet ? 15 : 0)
        .padding(.trailing, isTablet ? 15 : 0)
    }

    var coinsBalance: some View {
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
    }
}

// MARK: - Previews -

struct WritingWordsView_Previews: PreviewProvider {
    static var previews: some View {
        WritingWordsView(levelService: LevelServicePreviewMock(),
                         shopService: ShopServicePreviewMock(),
                         achievementService: AchievementServicePreviewMock())
    }
}
