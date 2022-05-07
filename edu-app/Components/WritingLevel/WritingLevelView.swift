//
//  WritingLevelView.swift
//  edu-app
//
//  Created by Filip Culig on 20.03.2022..
//

import AVKit
import SwiftUI

// MARK: - WritingLevelView -

struct WritingLevelView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @State var showVideoTutorialDialog: Bool = false
    private let drawingCanvasViewModel: DrawingCanvasViewModel
    private var player: AVPlayer?

    // MARK: - Initializer -

    public init(level: Level) {
        drawingCanvasViewModel = .init(level: level)

        guard let videoUrl = Bundle.main.path(forResource: level.name, ofType: "mp4") else { return }
        player = AVPlayer(url: URL(fileURLWithPath: videoUrl))
    }

    // MARK: - View components -

    var body: some View {
        ZStack {
            AppImage.houseBackgroundImage.image
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 3)
            drawingCanvasContainer
            buttons
        }
        .overlay(videoTutorialDialog)
        .onLoad { drawingCanvasViewModel.configureLineColor(context: moc) }
        .navigationBarHidden(true)
    }

    var drawingCanvasContainer: some View {
        VStack {
            Text(drawingCanvasViewModel.level.name ?? "")
                .foregroundColor(.green)
            ZStack {
                AppImage.drawingPanelBackgroundImage.image
                DrawingCanvasView(viewModel: drawingCanvasViewModel)
                    .padding(.leading, 49)
                    .padding(.trailing, 45)
                    .padding(.top, 29)
                    .padding(.bottom, 36)
            }
            .padding(.horizontal, 100)
        }
        .padding(.vertical, 50)
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
            .padding(.vertical, 45)
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
                    drawingCanvasViewModel.clearInk()
                } label: {
                    AppImage.trashCanButton.image
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70, alignment: .top)
                }
            }
            .padding(.vertical, 45)
        }
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
                // TODO: Close dialog button also

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
}

struct WritingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        let level = Level()

        level.name = "A"
        level.isLocked = false
        level.results = ["A"]
        level.numberOfLines = 3
        level.lockedImage = "A-locked"
        level.unlockedImage = "A-unlocked"

        return WritingLevelView(level: level)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
