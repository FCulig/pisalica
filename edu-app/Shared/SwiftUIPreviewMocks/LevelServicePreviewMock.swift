//
//  LevelServicePreviewMock.swift
//  edu-app
//
//  Created by Filip Culig on 27.05.2022..
//

import CoreData

// MARK: - LevelServicePreviewMock -

class LevelServicePreviewMock: LevelServiceful {
    var levels: [Level] = []

    func unlockLevelAfter(_: Level, context _: NSManagedObjectContext) {
        print("Unlocking level after")
    }
}
