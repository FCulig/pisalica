//
//  LevelSelectViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import Combine

// MARK: - LevelSelectViewModel -

final class LevelSelectViewModel: ObservableObject {
    // MARK: - Private properties
    
    private let achievementService: AchievementServiceful
    private let shopService: ShopServiceful
    private let levelService: LevelServiceful
    private let strokeManager: StrokeManager
    
    // MARK: - Public properties -

    @Published var levels: [Level] = []
    
    var balance: Int { shopService.balance }

    // MARK: - Initializer -

    public init(achievementService: AchievementServiceful,
                levelService: LevelServiceful,
                shopService: ShopServiceful,
                strokeManager: StrokeManager)
    {
        self.achievementService = achievementService
        self.shopService = shopService
        self.levelService = levelService
        self.strokeManager = strokeManager
    }
    
    private var cancellables: Set<AnyCancellable> = []
}

// MARK: - Public methods -

extension LevelSelectViewModel {
    func getLevels() {
        levels = levelService.getLetterLevels()
    }
    
    func writingLettersViewModel(for level: Level, isTablet: Bool) -> WritingLettersLevelViewModel {
        let drawingCanvasViewModel = DrawingCanvasViewModel(level: level,
                                                            levelService: levelService,
                                                            strokeManager: strokeManager)
        return WritingLettersLevelViewModel(level: level,
                                            drawingCanvasViewModel: drawingCanvasViewModel,
                                            levelService: levelService,
                                            achievementService: achievementService,
                                            shopService: shopService,
                                            isTablet: isTablet)
    }
}
