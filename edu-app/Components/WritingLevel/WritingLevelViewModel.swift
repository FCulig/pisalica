//
//  WritingLevelViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 11.05.2022..
//

import Combine
import CoreData
import SwiftUI

// MARK: - WritingLevelView.ViewModel -

extension WritingLevelView {
    class ViewModel: ObservableObject {
        private let achievementService: AchievementService
        private let levelService: LevelService
        private var correctAnswers: Int = 0
        private var totalAttempts: Int = 0
        private var cancellabels: Set<AnyCancellable> = []

        let level: Level
        var drawingCanvasViewModel: DrawingCanvasViewModel
        @Published var levelState: LevelState = .none
        @Published var isGameOver: Bool = false

        // MARK: - Initializer -

        public init(level: Level,
                    drawingCanvasViewModel: DrawingCanvasViewModel,
                    levelService: LevelService,
                    achievementService: AchievementService)
        {
            self.level = level
            self.drawingCanvasViewModel = drawingCanvasViewModel
            self.levelService = levelService
            self.achievementService = achievementService

            levelState = .guides(image: level.guideImage ?? "")

            subscribeToPublishers()
        }
    }
}

// MARK: - Public methods -

extension WritingLevelView.ViewModel {
    func endLevel(context: NSManagedObjectContext) {
        levelService.unlockLevelAfter(level, context: context)

        achievementService.updateAchievementProgress(achievementKey: "10_correct_letters", valueToBeAdded: correctAnswers, context: context)
        achievementService.updateAchievementProgress(achievementKey: "100_correct_letters", valueToBeAdded: correctAnswers, context: context)
        achievementService.updateAchievementProgress(achievementKey: "10_passed_levels", valueToBeAdded: 1, context: context)
        achievementService.updateAchievementProgress(achievementKey: "30_passed_levels", valueToBeAdded: 1, context: context)
    }
}

// MARK: - Private methods -

private extension WritingLevelView.ViewModel {
    func subscribeToPublishers() {
        drawingCanvasViewModel.isAnswerCorrect
            .sink { [weak self] in self?.updateLevelStatistics(wasAnswerCorrect: $0) }
            .store(in: &cancellabels)
    }

    func updateLevelStatistics(wasAnswerCorrect: Bool) {
        totalAttempts += 1
        correctAnswers += wasAnswerCorrect ? 1 : 0

        if correctAnswers == 1 {
            levelState = .outline(image: level.outlineImage ?? "")
        } else if correctAnswers == 2 {
            levelState = .none
        } else if correctAnswers == 3 {
            isGameOver = true
        }

        // DO NOT DELETE THIS COMMENT!!!

//        if correctAnswers < 3 {
//            levelState = .guides(image: level.guideImage ?? "")
//        } else if correctAnswers >= 3, correctAnswers < 6 {
//            levelState = .outline(image: level.outlineImage ?? "")
//        } else if correctAnswers >= 6, correctAnswers < 9 {
//            levelState = .none
//        } else if correctAnswers == 9 {
//            print("Gotov level")
//        }
    }
}

// MARK: - LevelState -

extension WritingLevelView.ViewModel {
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
