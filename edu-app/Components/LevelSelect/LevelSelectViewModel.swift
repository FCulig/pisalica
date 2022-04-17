//
//  LevelSelectViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import Foundation

// MARK: - LevelSelectView.ViewModel -

extension LevelSelectView {
    class ViewModel: ObservableObject {
        var totalPages: Int = 0
        var currentPage: Int = 0
        var paginatedLevels: [[Level]] = []

        @Published var displayedLevels: [Level] = []

        public init() {
            initializeLevels()
        }
    }
}

private extension LevelSelectView.ViewModel {
    func initializeLevels() {
        let levels = Levels.allCases
        let itemsPerPage = 12
        var tmp = 0
        totalPages = Int(ceil(Double(levels.count) / Double(itemsPerPage)))

        for _ in 0 ..< totalPages {
            var currentPage: [Level] = []
            for j in tmp ..< tmp + itemsPerPage {
                if levels.count > j {
                    currentPage.append(Level(isLocked: false, level: levels[j]))
                }
            }
            paginatedLevels.append(currentPage)
            currentPage = []
            tmp += itemsPerPage
        }

        displayedLevels = paginatedLevels[currentPage]
    }
}

extension LevelSelectView.ViewModel {
    func nextPage() {
        guard currentPage < totalPages else { return }
    }

    func previousPage() {
        guard currentPage > 1 else { return }
    }
}
