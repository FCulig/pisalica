//
//  LevelSelectViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import Foundation

// MARK: - LevelSelectView.ViewModel -

extension LevelSelectView {
    final class ViewModel: ObservableObject {
        let achievementService: AchievementServiceful
        let shopService: ShopServiceful
        var levelService: LevelServiceful
        var totalPages: Int = 0
        var currentPage: Int = 0
        var paginatedLevels: [[Level]] = []

        @Published var displayedLevels: [Level] = []
        @Published var showPreviousPageButton: Bool = false
        @Published var showNextPageButton: Bool = false

        // MARK: - Initializer -

        public init(achievementService: AchievementServiceful,
                    levelService: LevelServiceful,
                    shopService: ShopServiceful)
        {
            self.achievementService = achievementService
            self.shopService = shopService
            self.levelService = levelService
        }
    }
}

// MARK: - Private methods -

private extension LevelSelectView.ViewModel {
    func updatePageContent() {
        displayedLevels = paginatedLevels[currentPage]

        showNextPageButton = false
        showPreviousPageButton = false
        if currentPage > 0 { showPreviousPageButton = true }
        if currentPage < totalPages - 1 { showNextPageButton = true }
    }
}

// MARK: - Public methods -

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

    func getPaginatedLevels() {
        let levels = levelService.getLevels()

        paginatedLevels = []
        let itemsPerPage = 12
        var tmp = 0
        totalPages = Int(ceil(Double(levels.filter { $0.isWord == false }.count) / Double(itemsPerPage)))

        for _ in 0 ..< totalPages {
            var currentPage: [Level] = []
            for j in tmp ..< tmp + itemsPerPage {
                if levels.count > j, !levels[j].isWord {
                    currentPage.append(levels[j])
                }
            }
            paginatedLevels.append(currentPage)
            currentPage = []
            tmp += itemsPerPage
        }

        updatePageContent()
        levelService.levels = levels
    }
}
