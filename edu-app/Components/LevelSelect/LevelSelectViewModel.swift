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
//        var paginatedLevels: [[Level]] = []

//        @Published var displayedLevels: [Level] = []
        @Published var showPreviousPageButton: Bool = false
        @Published var showNextPageButton: Bool = false

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
//                    currentPage.append(Level(isLocked: false, level: levels[j]))
                }
            }
//            paginatedLevels.append(currentPage)
            currentPage = []
            tmp += itemsPerPage
        }

        updatePageContent()
    }

    func updatePageContent() {
//        displayedLevels = paginatedLevels[currentPage]

        showNextPageButton = false
        showPreviousPageButton = false
        if currentPage > 0 { showPreviousPageButton = true }
        if currentPage < totalPages - 1 { showNextPageButton = true }
    }
}

extension LevelSelectView.ViewModel {
    func nextPage() {
        guard currentPage < totalPages - 1 else { return }
        currentPage += 1
        updatePageContent()
    }

    func previousPage() {
        guard currentPage > 0 else { return }
        currentPage -= 1
        updatePageContent()
    }
}
