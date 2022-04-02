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
            DrawingCanvasView(viewModel: drawingCanvasViewModel)
            Button("Clear") {
                drawingCanvasViewModel.clearCanvasAction.send()
            }
        }
    }
}

struct WritingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        WritingLevelView(drawingCanvasViewModel: DrawingCanvasViewModel(level: Level.A,
                                                                        levelValidatorService: LevelValidatorService()))
    }
}
