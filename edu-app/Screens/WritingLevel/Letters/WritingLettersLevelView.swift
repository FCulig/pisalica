//
//  WritingLevelView.swift
//  edu-app
//
//  Created by Filip Culig on 20.03.2022..
//

import AVKit
import Combine
import SwiftUI

// MARK: - WritingLettersLevelView -

struct WritingLettersLevelView: View {
    // MARK: - Private properties -

    private var player: AVPlayer?

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
                                         shopService: shopService,
                                         isTablet: UIDevice.current.localizedModel == "iPad")
        _viewModel = StateObject(wrappedValue: wrappedViewModel)

        guard let videoUrl = Bundle.main.path(forResource: level.name, ofType: "mp4") else { return }
        player = AVPlayer(url: URL(fileURLWithPath: videoUrl))
    }

    // MARK: - Body -
    
    var body: some View {
        foregroundContent
            .background(
                background
            )
            .navigationBarHidden(true)
    }

    // MARK: - Foreground -
    
    var foregroundContent: some View {
        VStack(spacing: 0) {
            topRow
            letterWritingRow
        }
        .overlay(videoTutorialDialog)
        .overlay(gameOverDialog)
        .onAppear {
            BackgroundMusicService.shared.pause()
            viewModel.drawingCanvasViewModel.configureLineColor()
        }
    }
    
    // MARK: - Top part of the view -
    
    var topRow: some View {
        HStack(spacing: 0) {
            Button(action: { dismiss() },
                   image: AppImage.previousButton.image)
                .frame(height: 70, alignment: .top)
            
            Spacer()
            
            LevelProgressBarView(viewModel: .init(goal: 10, currentProgress: Just(5).eraseToAnyPublisher()))
                .frame(height: 70)
            
            Spacer()
            
            Button(action: { showVideoTutorialDialog = true },
                   image: AppImage.hintButton.image)
                .frame(height: 70, alignment: .top)
        }
    }
    
    // MARK: - Letter writing row -
    
    var letterWritingRow: some View {
        HStack(spacing: 0) {
            Spacer()
            
            drawingCanvasContainer
            
            Spacer()
            
            buttons
        }
    }

    var drawingCanvasContainer: some View {
        Panel {
            ZStack {
                viewModel.levelState.foregroundImage
                    .scaledToFit()
                    .padding(.all, viewModel.canvasImagePadding)
                
                DrawingCanvasView(viewModel: viewModel.drawingCanvasViewModel)
            }
        }
    }

    var buttons: some View {
        VStack(alignment: .trailing) {
            Spacer()
            
            if isTablet {
                VStack {
                    AppImage.zoomInButton.image
                        .scaledToFit()
                        .frame(height: 70, alignment: .top)
                        .onTapGesture {
                            viewModel.setCanvasImagePadding(0)
                        }
                    AppImage.zoomOutButton.image
                        .scaledToFit()
                        .frame(height: 70, alignment: .top)
                        .onTapGesture {
                            viewModel.setCanvasImagePadding(190)
                        }
                }
            }

            Spacer()
            Button(action: { viewModel.drawingCanvasViewModel.clearInk() },
                   image: AppImage.trashCanButton.image)
                .frame(height: 70, alignment: .top)
        }
        .padding(.vertical, isTablet ? 30 : 15)
        .padding(.leading, isTablet ? 15 : 0)
        .padding(.trailing, isTablet ? 15 : 0)
    }

    // MARK: - Video dialog -

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

                VStack {
                    HStack {
                        Spacer()
                        Button(action: { showVideoTutorialDialog = false },
                               image: AppImage.closeButton.image)
                            .frame(width: 65)
                            .padding(.vertical, isTablet ? 350 : 240)
                            .padding(.horizontal, isTablet ? 210 : 145)
                    }
                    Spacer()
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

    // MARK: - Game over dialog -

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

                    Button(action: { dismiss() },
                           image: AppImage.nextButtonV2.image)
                        .frame(width: 65)
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

// MARK: - Previews -

// Not working, constantly crashing

//struct WritingLettersLevelView_Previews: PreviewProvider {
//    static var previews: some View {
//        WritingLettersLevelView(level: Level(),
//                                levelService: LevelServicePreviewMock(),
//                                achievementService: AchievementServicePreviewMock(),
//                                shopService: ShopServicePreviewMock())
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDevice("iPhone 13 Pro Max")
//
//        WritingLettersLevelView(level: Level(),
//                                levelService: LevelServicePreviewMock(),
//                                achievementService: AchievementServicePreviewMock(),
//                                shopService: ShopServicePreviewMock())
//            .previewDevice("iPad Air (5th generation)")
//            .previewInterfaceOrientation(.landscapeLeft)
//    }
//}
