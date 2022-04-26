//
//  WritingLevelView.swift
//  edu-app
//
//  Created by Filip Culig on 20.03.2022..
//

import SwiftUI

// MARK: - WritingLevelView -

struct WritingLevelView: View {
    @Environment(\.dismiss) var dismiss
    let drawingCanvasViewModel: DrawingCanvasViewModel

    var body: some View {
        ZStack {
            AppImage.houseBackgroundImage.image
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 3)
            drawingCanvasContainer
            buttons
        }
        .navigationBarHidden(true)
    }

    var drawingCanvasContainer: some View {
        VStack {
            Text(drawingCanvasViewModel.level.name ?? "")
            DrawingCanvasView(viewModel: drawingCanvasViewModel)
                .cornerRadius(10)
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
                    print("Showing help")
                } label: {
                    AppImage.helpButton.image
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70, alignment: .top)
                }
                Spacer()
                Button {
                    drawingCanvasViewModel.clearCanvasAction.send()
                } label: {
                    AppImage.videoButton.image
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70, alignment: .top)
                }
            }
            .padding(.vertical, 45)
        }
    }
}

struct WritingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        WritingLevelView(drawingCanvasViewModel: DrawingCanvasViewModel(level: Level()))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
