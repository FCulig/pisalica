//
//  WritingLevelViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 11.05.2022..
//

import Combine
import CoreData
import SwiftUI

// MARK: - WritingLettersLevelViewModel -

final class WritingLettersLevelViewModel: ObservableObject {
    // MARK: - Private properties -

    private let achievementService: AchievementServiceful
    private let shopService: ShopServiceful
    private let levelService: LevelServiceful
    private let isTablet: Bool
    private var correctAnswers: Int = 0
    private var totalAttempts: Int = 0
    private var currentScore: Float = 0
    private var cancellabels: Set<AnyCancellable> = []
    private let isOutlinesLevelEnabledSubject: CurrentValueSubject<Bool, Never> = .init(false)
    private let isBlankLevelEnabledSubject: CurrentValueSubject<Bool, Never> = .init(false)
    private let highlightOutlineButtonSubject: PassthroughSubject<Void, Never> = .init()
    private let highlightCanvasButtonSubject: PassthroughSubject<Void, Never> = .init()
    private let progressSubject: CurrentValueSubject<Float, Never> = .init(0)

    // MARK: - Public properties -

    let level: Level
    let drawingCanvasViewModel: DrawingCanvasViewModel
    let progressBarViewModel: LevelProgressBarViewModel
    
    @Published var levelState: LevelState = .none
    @Published var isGameOver: Bool = false
    @Published var endGameRecap: [String: Int] = [:]
    @Published var totalCoinsReward = 0
    @Published var endGameStars: Image = AppImage.oneStar.image
    @Published var canvasImagePadding: CGFloat = 0

    // MARK: - Initializer -

    public init(level: Level,
                drawingCanvasViewModel: DrawingCanvasViewModel,
                levelService: LevelServiceful,
                achievementService: AchievementServiceful,
                shopService: ShopServiceful,
                isTablet: Bool)
    {
        self.level = level
        self.drawingCanvasViewModel = drawingCanvasViewModel
        self.levelService = levelService
        self.achievementService = achievementService
        self.shopService = shopService
        self.isTablet = isTablet

        levelState = .guides(image: level.guideImage ?? "")
        progressBarViewModel = LevelProgressBarViewModel(goal: 9,
                                                         level: level,
                                                         currentProgress: progressSubject.eraseToAnyPublisher(),
                                                         outlineButtonAnimationPublisher: highlightOutlineButtonSubject.eraseToAnyPublisher(),
                                                         outlineButtonEnabledPublisher: isOutlinesLevelEnabledSubject.eraseToAnyPublisher(),
                                                         canvasButtonAnimationPublisher: highlightCanvasButtonSubject.eraseToAnyPublisher(),
                                                         canvasButtonEnabledPublisher: isBlankLevelEnabledSubject.eraseToAnyPublisher())

        subscribeToPublishers()
        getCanvasImagePadding()
    }
}

// MARK: - Public methods -

extension WritingLettersLevelViewModel {
    func setCanvasImagePadding(_ padding: CGFloat) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(padding, forKey: "canvasImagePadding")
        canvasImagePadding = padding
    }
}

// MARK: - Private methods -

private extension WritingLettersLevelViewModel {
    func subscribeToPublishers() {
        drawingCanvasViewModel.isAnswerCorrect
            .sink { [weak self] in self?.updateLevelStatistics(wasAnswerCorrect: $0) }
            .store(in: &cancellabels)
        
        progressBarViewModel.guidesButtonTapped
            .sink { [weak self] in self?.levelState = .guides(image: self?.level.guideImage ?? "") }
            .store(in: &cancellabels)
        
        progressBarViewModel.outlineButtonTapped
            .sink { [weak self] in self?.levelState = .outline(image: self?.level.outlineImage ?? "") }
            .store(in: &cancellabels)
        
        progressBarViewModel.canvasButtonTapped
            .sink { [weak self] in self?.levelState = .none }
            .store(in: &cancellabels)
    }

    func getCanvasImagePadding() {
        let userDefaults = UserDefaults.standard

        if userDefaults.integer(forKey: "canvasImagePadding") > 0 {
            canvasImagePadding = CGFloat(userDefaults.integer(forKey: "canvasImagePadding"))
        } else {
            canvasImagePadding = isTablet ? 220 : 0
        }
    }

    func updateLevelStatistics(wasAnswerCorrect: Bool) {
        totalAttempts += 1
        correctAnswers += wasAnswerCorrect ? 1 : 0

        updateTotalScore(wasAnswerCorrect: wasAnswerCorrect)
    }

    func endLevel() {
        achievementService.updateAchievementProgress(achievementKey: "10_correct_letters", valueToBeAdded: correctAnswers)
        achievementService.updateAchievementProgress(achievementKey: "100_correct_letters", valueToBeAdded: correctAnswers)
        achievementService.updateAchievementProgress(achievementKey: "10_passed_levels", valueToBeAdded: 1)
        achievementService.updateAchievementProgress(achievementKey: "30_passed_levels", valueToBeAdded: 1)

        levelService.unlockLevelAfter(level)
    }

    func updateTotalScore(wasAnswerCorrect: Bool) {
        // If we want negative points
        guard wasAnswerCorrect else {
//            var newScore = currentScore
//
//            if currentScore < 3 {
//                newScore -= 0.5
//
//                isOutlinesLevelEnabled.send(false)
//                isBlankLevelEnabled.send(false)
//            } else if currentScore >= 3, currentScore < 6 {
//                newScore -= 0.5
//
//                if currentScore - 0.5 < 3 {
//                    isOutlinesLevelEnabled.send(false)
//                    isBlankLevelEnabled.send(false)
//                    configureGuidesLevel()
//                }
//            } else if currentScore >= 6, currentScore < 9 {
//                newScore -= 0.5
//
//                if currentScore - 0.5 < 6 {
//                    isBlankLevelEnabled.send(false)
//                    configureOutlinesLevel()
//                }
//            }
//
//            currentScore = newScore
//            progress.send(currentScore)
            return
        }

        var newScore = currentScore

        if currentScore < 3 {
            newScore += 1

            if newScore >= 3 {
                isOutlinesLevelEnabledSubject.send(true)
            }
        } else if currentScore >= 3, currentScore < 6 {
            if case .none = levelState { return }
            if case .guides = levelState {
                highlightOutlineButtonSubject.send()
                return
            }

            newScore += 1
            if currentScore + 1 >= 6 {
                isBlankLevelEnabledSubject.send(true)
            }
        } else if currentScore >= 6, currentScore < 9 {
            if case .guides = levelState {
                highlightCanvasButtonSubject.send()
                return
            }
            if case .outline = levelState {
                highlightCanvasButtonSubject.send()
                return
            }

            newScore += 1
            if newScore >= 9 {
                newScore = 9
                isGameOver = true
                updateEndGameRecapData()
            }
        }

        progressSubject.send(newScore)
        currentScore = newScore
    }

    func updateEndGameRecapData() {
        let correctPercentage = Float(correctAnswers) / Float(totalAttempts) * 100

        totalCoinsReward += 5
        endGameRecap["Prijeđena razina"] = 5

        if correctPercentage > 85 {
            totalCoinsReward += 5
            endGameRecap["3 Zvijezdice"] = 5
            endGameStars = AppImage.threeStar.image
        } else if correctPercentage <= 85, correctPercentage > 60 {
            totalCoinsReward += 2
            endGameRecap["2 Zvijezdice"] = 2
            endGameStars = AppImage.twoStar.image
        } else {
            totalCoinsReward += 1
            endGameRecap["1 Zvijezdica"] = 1
            endGameStars = AppImage.oneStar.image
        }

        shopService.updateCoins(amountToBeAdded: totalCoinsReward)

        achievementService.updateAchievementProgress(achievementKey: "10_coins", valueToBeAdded: totalCoinsReward)
        achievementService.updateAchievementProgress(achievementKey: "100_coins", valueToBeAdded: totalCoinsReward)

        endLevel()
    }
}

// MARK: - LevelState -

extension WritingLettersLevelViewModel {
    enum LevelState {
        case none
        case outline(image: String)
        case guides(image: String)

        var backgroundImage: Image? {
            switch self {
            case .none:
                return AppImage.drawingPanelBackgroundImage.image
            case .outline, .guides:
                return AppImage.drawingPanelTutorialBackgroundImage.image
            }
        }

        var foregroundImage: Image? {
            switch self {
            case .none:
                return nil
            case let .outline(image), let .guides(image):
                return Image(image).resizable()
            }
        }
    }
}
