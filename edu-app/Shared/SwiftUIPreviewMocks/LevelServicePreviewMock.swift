//
//  LevelServicePreviewMock.swift
//  edu-app
//
//  Created by Filip Culig on 27.05.2022..
//

// MARK: - LevelServicePreviewMock -

class LevelServicePreviewMock: LevelServiceful {
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

    func getRandomWordLevel() -> Level {
        return Level()
    }
}
