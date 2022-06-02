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

        private let isTablet: Bool
        private var cancellables: Set<AnyCancellable> = []
        private var isShowOutlineLevelButtonEnabledSubject: CurrentValueSubject<Bool, Never>
        private var isShowBlankLevelButtonEnabledSubject: CurrentValueSubject<Bool, Never>
        private var progress: CurrentValueSubject<Float, Never>

        // MARK: - Public properties -

        var showGuidesLevel: () -> Void
        var showOutlineLevel: () -> Void
        var showBlankLevel: () -> Void

        let level: Level
        @Published var progressGoal: Float = 0
        @Published var currentProgress: Float = 0
        @Published var trailingPadding: CGFloat = 0
        @Published var isShowOutlineLevelButtonEnabled: Bool = false
        @Published var isShowBlankLevelButtonEnabled: Bool = false

        // MARK: - Initializer -

        public init(progressGoal: Float,
                    showGuidesLevel: @escaping () -> Void,
                    showOutlineLevel: @escaping () -> Void,
                    showBlankLevel: @escaping () -> Void,
                    isShowOutlineLevelButtonEnabled: CurrentValueSubject<Bool, Never>,
                    isShowBlankLevelButtonEnabled: CurrentValueSubject<Bool, Never>,
                    progress: CurrentValueSubject<Float, Never>,
                    level: Level,
                    isTablet: Bool)
        {
            self.progressGoal = progressGoal
            self.showGuidesLevel = showGuidesLevel
            self.showOutlineLevel = showOutlineLevel
            self.showBlankLevel = showBlankLevel
            isShowOutlineLevelButtonEnabledSubject = isShowOutlineLevelButtonEnabled
            isShowBlankLevelButtonEnabledSubject = isShowBlankLevelButtonEnabled
            self.progress = progress
            self.level = level
            self.isTablet = isTablet

            subscribeSubjectChanges()
        }
    }
}

// MARK: - Public methods -

extension LevelProgressBarView.ViewModel {
    func updateTrailingPadding() {
        let maxIndicatorWidth = CGFloat(isTablet ? 865 : 546)
        let progressPercentage = currentProgress / progressGoal
        let indicatorWidthToBe = maxIndicatorWidth * CGFloat(progressPercentage)
        trailingPadding = maxIndicatorWidth - indicatorWidthToBe
    }
}

// MARK: - Initial setup -

private extension LevelProgressBarView.ViewModel {
    func subscribeSubjectChanges() {
        progress
            .sink { [weak self] in
                self?.currentProgress = $0
                self?.updateTrailingPadding()
            }
            .store(in: &cancellables)

        isShowOutlineLevelButtonEnabledSubject
            .sink { [weak self] in
                self?.isShowOutlineLevelButtonEnabled = $0
            }
            .store(in: &cancellables)

        isShowBlankLevelButtonEnabledSubject
            .sink { [weak self] in
                self?.isShowBlankLevelButtonEnabled = $0
            }
            .store(in: &cancellables)
    }
}
