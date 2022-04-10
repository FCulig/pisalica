//
//  WritingLevelView.swift
//  edu-app
//
//  Created by Filip Culig on 20.03.2022..
//

import SwiftUI

// TODO: https://stackoverflow.com/questions/60700609/saving-pencilkit-image-swiftui

// MARK: - WritingLevelView -

struct WritingLevelView: View {
    let drawingCanvasViewModel: DrawingCanvasViewModel

    var body: some View {
        VStack {
            drawingCanvasViewModel.level.unlockedImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, alignment: .center)
            DrawingCanvasView(viewModel: drawingCanvasViewModel)
                .cornerRadius(10)
                .padding([.leading, .bottom, .trailing], 30.0)
            Button(action: {
                drawingCanvasViewModel.clearCanvasAction.send()
            }) {
                AppImage.trashCanButton.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, alignment: .center)
            }
            .foregroundColor(/*@START_MENU_TOKEN@*/ .white/*@END_MENU_TOKEN@*/)
        }
        .background(Color.cyan)
    }
}

struct WritingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        WritingLevelView(drawingCanvasViewModel: DrawingCanvasViewModel(level: Level.A,
                                                                        levelValidatorService: LevelValidatorService()))
    }
}
