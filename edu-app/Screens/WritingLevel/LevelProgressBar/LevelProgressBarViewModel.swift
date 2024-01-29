//
//  LevelProgressBarViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 31.05.2022..
//

import Combine
import SwiftUI

// MARK: - LevelProgressBarView.ViewModel -

extension LevelProgressBarView {
    final class ViewModel: ObservableObject {
        // MARK: - Private properties -

        private let goal: Float
        private let currentProgressSubject: AnyPublisher<Float, Never>
        
        private var currentProgress: Float = 0 {
            didSet {
                updateView()
            }
        }
        
        private var cancellables: Set<AnyCancellable> = []
//        private var isShowOutlineLevelButtonEnabledSubject: AnyPublisher<Bool, Never>
//        private var isShowBlankLevelButtonEnabledSubject: AnyPublisher<Bool, Never>
//        private var shouldHighlightOutlineButtonSubject: AnyPublisher<Bool, Never>
//        private var shouldHighlightCanvasButtonSubject: AnyPublisher<Bool, Never>
//        private var progress: AnyPublisher<Float, Never>

        // MARK: - Public properties -
        
//        let level: Level
//
//        var showGuidesLevel: () -> Void
//        var showOutlineLevel: () -> Void
//        var showBlankLevel: () -> Void
        
        var progressBarWidth: CGFloat = 0 {
            didSet {
                updateView()
            }
        }
        
        @Published var checkpointSpacing: CGFloat = 0
        @Published var progressIndicatorWidth: CGFloat = 0
        
        

//        @Published var progressGoal: Float = 0
//        @Published var currentProgress: Float = 0
//        @Published var trailingPadding: CGFloat = 0
//        @Published var isShowOutlineLevelButtonEnabled: Bool = false
//        @Published var isShowBlankLevelButtonEnabled: Bool = false
//        @Published var shouldHighlightOutlineButton: Bool = false
//        @Published var shouldHighlightCanvasButton: Bool = false

        // MARK: - Initializer -

        public init(goal: Float, currentProgress: AnyPublisher<Float, Never>) {
            self.goal = goal
            self.currentProgressSubject = currentProgress
        }
        
        func updateView() {
            didUpdateProgressBarWidth()
            updateProgressIndicatorWidth()
        }
    }
}

// MARK: - Initial setup -

private extension LevelProgressBarView.ViewModel {
    func subscribeSubjectChanges() {
        currentProgressSubject
            .assignWeak(to: \.currentProgress, on: self)
            .store(in: &cancellables)
        
//        progress
//            .assignWeak(to: \.currentProgress, on: self)
//            .store(in: &cancellables)
//
//        isShowOutlineLevelButtonEnabledSubject
//            .assignWeak(to: \.isShowOutlineLevelButtonEnabled, on: self)
//            .store(in: &cancellables)
//
//        isShowBlankLevelButtonEnabledSubject
//            .assignWeak(to: \.isShowBlankLevelButtonEnabled, on: self)
//            .store(in: &cancellables)
//
//        shouldHighlightOutlineButtonSubject
//            .assignWeak(to: \.shouldHighlightOutlineButton, on: self)
//            .store(in: &cancellables)
//
//        shouldHighlightCanvasButtonSubject
//            .assignWeak(to: \.shouldHighlightCanvasButton, on: self)
//            .store(in: &cancellables)
    }
}

// MARK: - Private methods -

private extension LevelProgressBarView.ViewModel {
    func didUpdateProgressBarWidth() {
        checkpointSpacing = progressBarWidth / 3 // - widthOfImages * 3
    }
    
    func updateProgressIndicatorWidth() {
        let progressPercentage = currentProgress / goal
        progressIndicatorWidth = CGFloat(progressPercentage) * progressBarWidth
        
        print(progressPercentage)
        print(progressIndicatorWidth)
    }
}
