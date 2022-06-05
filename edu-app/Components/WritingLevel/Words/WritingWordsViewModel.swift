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

        @Published var drawingCanvasViewModel: DrawingCanvasViewModel

        // MARK: - Initializer -

        public init(levelService: LevelServiceful) {
            self.levelService = levelService
            drawingCanvasViewModel = DrawingCanvasViewModel(level: Level(),
                                                            levelService: levelService)

            newLevel()
        }
    }
}

// MARK: - Public methods -

extension WritingWordsView.ViewModel {
    func newLevel() {
        let level = levelService.getRandomWordLevel()

        drawingCanvasViewModel = DrawingCanvasViewModel(level: level,
                                                        levelService: levelService,
                                                        clearOnCorrect: false)
    }
}
