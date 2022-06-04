//
//  WritingWordsViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 04.06.2022..
//

import SwiftUI

// MARK: - WritingWordsView.ViewModel -

extension WritingWordsView {
    class ViewModel: ObservableObject {
        // MARK: - Private properties -

        let levelService: LevelServiceful

        // MARK: - Public properties -

        var drawingCanvasViewModel: DrawingCanvasViewModel

        // MARK: - Initializer -

        public init(levelService: LevelServiceful) {
            self.levelService = levelService
            drawingCanvasViewModel = DrawingCanvasViewModel(level: Level(),
                                                            levelService: levelService)

            configureFirstLevel()
        }
    }
}

private extension WritingWordsView.ViewModel {
    func configureFirstLevel() {
        drawingCanvasViewModel = DrawingCanvasViewModel(level: Level(),
                                                        levelService: levelService)
    }
}
