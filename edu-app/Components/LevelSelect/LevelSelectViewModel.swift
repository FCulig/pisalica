//
//  LevelSelectViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import CoreData
import Foundation

// MARK: - LevelSelectView.ViewModel -

extension LevelSelectView {
    class ViewModel: ObservableObject {
        var totalPages: Int = 0
        var currentPage: Int = 0
        var paginatedLevels: [[Level]] = []

        @Published var displayedLevels: [Level] = []
        @Published var showPreviousPageButton: Bool = false
        @Published var showNextPageButton: Bool = false

        public init() {}
    }
}

private extension LevelSelectView.ViewModel {
    func updatePageContent() {
        displayedLevels = paginatedLevels[currentPage]

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

    func getPaginatedLevels(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Level> = Level.fetchRequest()
        var levels: [Level] = []

        do {
            levels = try context.fetch(fetchRequest)
            paginatedLevels = []
            let itemsPerPage = 12
            var tmp = 0
            totalPages = Int(ceil(Double(levels.count) / Double(itemsPerPage)))

            for _ in 0 ..< totalPages {
                var currentPage: [Level] = []
                for j in tmp ..< tmp + itemsPerPage {
                    if levels.count > j {
                        currentPage.append(levels[j])
                    }
                }
                paginatedLevels.append(currentPage)
                currentPage = []
                tmp += itemsPerPage
            }

            updatePageContent()
        } catch { print(error) }
    }
}
