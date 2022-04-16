//
//  LevelSelectViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import Foundation

extension LevelSelectView {
    class ViewModel: ObservableObject {
        @Published var levels: [Level] = []

        public init() {
            initializeLevels()
        }
    }
}

private extension LevelSelectView.ViewModel {
    func initializeLevels() {
        Levels.allCases.forEach {
            levels += [Level(isLocked: false, level: $0)]
        }
    }
}
