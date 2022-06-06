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

        private var isInitialLoad = true
        private let levelService: LevelServiceful
        private var cancellabels: Set<AnyCancellable> = []
        private var onWordCorrectWithHintsSubject: PassthroughSubject<Void, Never> = .init()

        // MARK: - Public properties -

        @Published var shopService: ShopServiceful
        @Published var drawingCanvasViewModel: DrawingCanvasViewModel
        @Published var level: Level
        @Published var visibleHints: [Int: Bool] = [:]
        @Published var wordName: String = ""

        // MARK: - Initializer -

        public init(levelService: LevelServiceful, shopService: ShopServiceful) {
            self.levelService = levelService
            self.shopService = shopService

            level = Level()
            drawingCanvasViewModel = DrawingCanvasViewModel(level: Level(),
                                                            levelService: levelService,
                                                            onWordCorrectWithHints: onWordCorrectWithHintsSubject)

            newLevel()
            subscribeToActions()
            isInitialLoad = false
        }
    }
}

// MARK: - Public methods -

extension WritingWordsView.ViewModel {
    func newLevel() {
        level = levelService.getRandomWordLevel()
        drawingCanvasViewModel.level = level

        wordName = level.name ?? "xxxxx"

        level.name?.enumerated().forEach { index, _ in
            visibleHints[index] = false
        }

        if !isInitialLoad { shopService.updateCoins(amountToBeAdded: 1) }
    }

    func buyNewHint() {
        let hintsArray = Array(visibleHints.keys)

        // Provjeri da nisu svi hintovi kupljeni
        var areAllHintsBought = true
        hintsArray.forEach { hint in
            if visibleHints[hint] == false {
                areAllHintsBought = false
            }
        }

        guard !areAllHintsBought else { return }

        // Kupi hint
        var isHintBought = false
        repeat {
            let randomLetter = hintsArray[Int.random(in: 0 ..< hintsArray.count)]

            if visibleHints[randomLetter] == false {
                var hasBeenRecognized = false
                level.name?.enumerated().forEach { index, _ in
                    if randomLetter == index { hasBeenRecognized = drawingCanvasViewModel.recognizedLetterIndexes.contains(index) }
                }

                if !hasBeenRecognized {
                    visibleHints[randomLetter] = true
                    shopService.updateCoins(amountToBeAdded: -1)
                    isHintBought = true

                    level.name?.enumerated().forEach { index, _ in
                        if index == randomLetter {
                            drawingCanvasViewModel.recognizedLetterIndexes.append(index)
                        }
                    }
                }
            }
        } while !isHintBought

        if drawingCanvasViewModel.recognizedLetterIndexes.count == (level.name?.count ?? -1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.onWordCorrectWithHintsSubject.send()
            }
        }
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
