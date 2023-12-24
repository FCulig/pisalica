//
//  LevelServicePreviewMock.swift
//  edu-app
//
//  Created by Filip Culig on 27.05.2022..
//

// MARK: - LevelServicePreviewMock -

final class LevelServicePreviewMock: LevelServiceful {
    var levels: [Level] = []

    func unlockLevelAfter(_: Level) {
        print("Unlocking level after")
    }

    func configureLevelData() {
        print("Configuring level data")
    }

    func getLineColorCode() -> String {
        return "LineColor"
    }

    func getLevels() -> [Level] {
        return []
    }
    
    func getLetterLevels() -> [Level] {
        return []
    }
    
    func getWordLevels() -> [Level] {
        return []
    }

    func getRandomWordLevel() -> Level {
        return Level()
    }

    func getLevelForName(_: String) -> Level? {
        return nil
    }
}
