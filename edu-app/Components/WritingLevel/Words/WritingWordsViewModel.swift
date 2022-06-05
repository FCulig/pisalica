//
//  WritingWordsViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 04.06.2022..
//

import Combine
import SwiftUI

// MARK: - WritingWordsView.ViewModel -

extension WritingWordsView {
    class ViewModel: ObservableObject {
        // MARK: - Private properties -

        private let levelService: LevelServiceful
        private var cancellabels: Set<AnyCancellable> = []

        // MARK: - Public properties -

        @Published var drawingCanvasViewModel: DrawingCanvasViewModel
        @Published var level: Level

        // MARK: - Initializer -

        public init(levelService: LevelServiceful) {
            self.levelService = levelService
            level = Level()
            drawingCanvasViewModel = DrawingCanvasViewModel(level: Level(),
                                                            levelService: levelService)

            newLevel()
            subscribeToActions()
        }
    }
}

// MARK: - Public methods -

extension WritingWordsView.ViewModel {
    func newLevel() {
        level = levelService.getRandomWordLevel()
        drawingCanvasViewModel.level = level
    }
}

// MARK: - Private methods -

private extension WritingWordsView.ViewModel {
    func subscribeToActions() {
        drawingCanvasViewModel.onWordCorrect
            .sink { [weak self] in self?.newLevel() }
            .store(in: &cancellabels)
    }
}
