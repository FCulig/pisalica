//
//  WritingLevelView.swift
//  edu-app
//
//  Created by Filip Culig on 20.03.2022..
//

import AVKit
import Combine
import SwiftUI

// MARK: - WritingLevelView -

struct WritingLevelView: View {
    // MARK: - Private properties -

    private var player: AVPlayer?
    private let isTablet = UIDevice.current.localizedModel == "iPad"

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ViewModel
    @State private var showVideoTutorialDialog: Bool = false

    // MARK: - Initializer -

    public init(level: Level,
                levelService: LevelServiceful,
                achievementService: AchievementServiceful,
                shopService: ShopServiceful)
    {
        let drawingCanvasViewModel = DrawingCanvasViewModel(level: level, levelService: levelService)

        let wrappedViewModel = ViewModel(level: level,
                                         drawingCanvasViewModel: drawingCanvasViewModel,
                                         levelService: levelService,
                                         achievementService: achievementService,
                                         shopService: shopService)
        _viewModel = StateObject(wrappedValue: wrappedViewModel)

        guard let videoUrl = Bundle.main.path(forResource: level.name, ofType: "mp4") else { return }
        player = AVPlayer(url: URL(fileURLWithPath: videoUrl))
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
        .overlay(videoTutorialDialog)
        .overlay(gameOverDialog)
        .onLoad { viewModel.drawingCanvasViewModel.configureLineColor() }
    }

    var drawingCanvasContainer: some View {
        VStack {
            LevelProgressBarView(viewModel: .init(progressGoal: 9, progress: viewModel.progress))
                .frame(height: 125)
                .padding(.top, -75)
//            Text(viewModel.drawingCanvasViewModel.level.name ?? "")
//                .foregroundColor(.clear)
            ZStack {
                viewModel.levelState.backgroundImage
                if viewModel.level.isDiacritical {
                    viewModel.levelState.foregroundImage
                        .scaledToFit()
                        .padding(.top, 25)
                        .padding(.all, isTablet ? 220 : 0)
                } else {
                    viewModel.levelState.foregroundImage
                        .scaledToFit()
                        .padding(.all, isTablet ? 220 : 0)
                }
                DrawingCanvasView(viewModel: viewModel.drawingCanvasViewModel)
                    .padding(.leading, 49)
                    .padding(.trailing, 45)
                    .padding(.top, 29)
                    .padding(.bottom, 36)
            }
            .padding(.top, -20)
        }
        .padding(.top, 70)
        .padding(.bottom, 10)
        .padding(.horizontal, 130)
    }

    var buttons: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    AppImage.previousButton.image
                        .aspectRatio(contentMode: .fit)
                }
                .frame(height: 70, alignment: .top)
                Spacer()
            }
            Spacer()
            VStack(alignment: .trailing) {
                Button {
                    showVideoTutorialDialog = true
                } label: {
                    AppImage.videoButton.image
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70, alignment: .top)
                }
                Spacer()
                Button {
                    viewModel.drawingCanvasViewModel.clearInk()
                } label: {
                    AppImage.trashCanButton.image
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70, alignment: .top)
                }
            }
        }
        .padding(.vertical, 15)
        .padding(.leading, isTablet ? 15 : 0)
        .padding(.trailing, isTablet ? 15 : 0)
    }

    var videoTutorialDialog: some View {
        ZStack {
            if showVideoTutorialDialog {
                Rectangle()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .foregroundColor(.black.opacity(0.85))
                AppImage.videoPanelBackgroundImage.image
                    .scaledToFit()
                    .padding(.vertical, 60)
                    .onTapGesture {
                        showVideoTutorialDialog = false
                    }

                if let player = player {
                    PlayerView(player: player)
                        .frame(width: 250, height: 250)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                player.play()
                            }
                        }
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("No video yet.")
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    var gameOverDialog: some View {
        ZStack {
            if viewModel.isGameOver {
                Rectangle()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .foregroundColor(.black.opacity(0.85))
                gameOverDialogContent
            }
        }
    }

    var gameOverDialogContent: some View {
        ZStack {
            AppImage.levelOverBackground.image
                .padding(.top, 280)
                .padding(.bottom, 260)
                .frame(width: 850)

            VStack {
                ZStack {
                    AppImage.ribbon.image
                        .scaledToFit()
                        .frame(width: 420)

                    viewModel.endGameStars
                        .scaledToFit()
                        .frame(width: 260)
                        .padding(.bottom, 75)
                }
                .padding(.top, 190)

                Spacer()
            }

            gameOverRewards

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button {
                        dismiss()
                        viewModel.endLevel()
                    } label: {
                        AppImage.nextButtonV2.image
                            .scaledToFit()
                            .frame(width: 65)
                    }
                }
                .padding(.bottom, 220)
            }
            .frame(width: 400)
        }
        .padding(.top, isTablet ? 150 : 0)
        .padding(.bottom, isTablet ? 150 : 0)
    }

    var gameOverRewards: some View {
        VStack {
            ForEach(Array(viewModel.endGameRecap.keys), id: \.self) { key in
                HStack {
                    Text(key)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 0, x: 3, y: 2)
                        .font(.system(size: isTablet ? 30 : 25).weight(.bold))

                    Spacer()

                    HStack {
                        AppImage.coins.image
                            .scaledToFit()
                            .frame(height: 30)
                        Text("\(viewModel.endGameRecap[key] ?? 0)")
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 0, x: 3, y: 2)
                            .font(.system(size: isTablet ? 30 : 25).weight(.bold))
                            .padding(.leading, -12)
                    }
                }
            }

            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color(uiColor: UIColor(hex: "#964B00") ?? .brown))

            HStack {
                Text("Ukupno")
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, x: 3, y: 2)
                    .font(.system(size: isTablet ? 30 : 25).weight(.bold))

                Spacer()

                HStack {
                    AppImage.coins.image
                        .scaledToFit()
                        .frame(height: 30)
                    Text("\(viewModel.totalCoinsReward)")
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 0, x: 3, y: 2)
                        .font(.system(size: isTablet ? 30 : 25).weight(.bold))
                        .padding(.leading, -12)
                }
            }
        }
        .frame(width: 300)
        .padding(.top, 70)
    }
}

struct WritingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        WritingLevelView(level: Level(),
                         levelService: LevelServicePreviewMock(),
                         achievementService: AchievementServicePreviewMock(),
                         shopService: ShopServicePreviewMock())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        WritingLevelView(level: Level(),
                         levelService: LevelServicePreviewMock(),
                         achievementService: AchievementServicePreviewMock(),
                         shopService: ShopServicePreviewMock())
            .previewDevice("iPad Air (5th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
