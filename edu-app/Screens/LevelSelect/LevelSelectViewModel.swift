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

        @Published var levels: [Level] = []

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

// MARK: - Public methods -

extension LevelSelectView.ViewModel {
    func getLevels() {
        levels = levelService.getLetterLevels()
    }
}
