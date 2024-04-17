//
//  WritingWordsViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 04.06.2022..
//

import Combine
import SwiftUI

// MARK: - WritingWordsViewModel -
final class WritingWordsViewModel: ObservableObject {
    // MARK: - Private properties -

    private let levelService: LevelServiceful
    private let achievementService: AchievementServiceful
    private var isInitialLoad = true
    private var cancellabels: Set<AnyCancellable> = []
    private var onWordCorrectWithHintsSubject: PassthroughSubject<Void, Never> = .init()

    // MARK: - Public properties -

    @Published var shopService: ShopServiceful
    @Published var drawingCanvasViewModel: DrawingCanvasViewModel
    @Published var level: Level
    @Published var visibleHints: [Int: Bool] = [:]
    @Published var wordName: String = ""
    @Published var canBuyHint: Bool = true
    @Published var shouldHighlightCoinsBalance: Bool = false

    // MARK: - Initializer -

    public init(levelService: LevelServiceful,
                shopService: ShopServiceful,
                achievementService: AchievementServiceful,
                strokeManager: StrokeManager) {
        self.levelService = levelService
        self.shopService = shopService
        self.achievementService = achievementService

        level = Level()
        drawingCanvasViewModel = DrawingCanvasViewModel(level: Level(),
                                                        levelService: levelService,
                                                        strokeManager: strokeManager,
                                                        onWordCorrectWithHints: onWordCorrectWithHintsSubject)
        newLevel()
        
        subscribeToActions()
        isInitialLoad = false
    }
}

// MARK: - Public methods -

extension WritingWordsViewModel {
    func newLevel() {
        level = levelService.getRandomWordLevel()
        drawingCanvasViewModel.level = level

        wordName = level.name ?? "xxxxx"

        level.name?.enumerated().forEach { index, _ in
            visibleHints[index] = false
        }

        updateCoinsBalanceStatus()
        if !isInitialLoad {
            shopService.updateCoins(amountToBeAdded: 5)

            achievementService.updateAchievementProgress(achievementKey: "10_coins", valueToBeAdded: 5)
            achievementService.updateAchievementProgress(achievementKey: "100_coins", valueToBeAdded: 5)

            achievementService.updateAchievementProgress(achievementKey: "10_correct_words", valueToBeAdded: 1)
            achievementService.updateAchievementProgress(achievementKey: "100_correct_words", valueToBeAdded: 1)

            guard let name = level.name else { return }

            achievementService.updateAchievementProgress(achievementKey: "10_correct_letters", valueToBeAdded: name.count)
            achievementService.updateAchievementProgress(achievementKey: "100_correct_letters", valueToBeAdded: name.count)
        }
    }

    func buyNewHint() {
        guard canBuyHint else {
            shouldHighlightCoinsBalance = true
            return
        }

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
                    shopService.updateCoins(amountToBeAdded: -3)
                    isHintBought = true
                    updateCoinsBalanceStatus()

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

private extension WritingWordsViewModel {
    func subscribeToActions() {
        drawingCanvasViewModel.onWordCorrect
            .sink { [weak self] in self?.newLevel() }
            .store(in: &cancellabels)
    }

    func updateCoinsBalanceStatus() {
        canBuyHint = shopService.balance >= 3
    }
}
