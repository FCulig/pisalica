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
    class ViewModel: ObservableObject {
        // MARK: - Private properties -

        private var cancellables: Set<AnyCancellable> = []
        private var progress: CurrentValueSubject<Float, Never>

        // MARK: - Public properties -

        @Published var progressGoal: Float = 0
        @Published var currentProgress: Float = 0
        @Published var trailingPadding: CGFloat = 0

        // MARK: - Initializer -

        public init(progressGoal: Float, progress: CurrentValueSubject<Float, Never>) {
            self.progressGoal = progressGoal
            self.progress = progress

            subscribeProgressChanges()
        }
    }
}

// MARK: - Public methods -

extension LevelProgressBarView.ViewModel {
    func updateTrailingPadding() {
        let maxIndicatorWidth = CGFloat(546)
        let progressPercentage = currentProgress / progressGoal
        let indicatorWidthToBe = maxIndicatorWidth * CGFloat(progressPercentage)
        trailingPadding = maxIndicatorWidth - indicatorWidthToBe

        print("Max width: \(maxIndicatorWidth)")
        print("Percentage: \(progressPercentage)")
        print("Indicator padding: \(trailingPadding)")
        print("Score: \(progress.value)")

        print("Updating padding")
    }
}

// MARK: - Initial setup -

private extension LevelProgressBarView.ViewModel {
    func subscribeProgressChanges() {
        progress
            .sink { [weak self] in
                self?.currentProgress = $0
                self?.updateTrailingPadding()
            }
            .store(in: &cancellables)
    }
}
