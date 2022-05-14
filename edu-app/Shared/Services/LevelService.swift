//
//  LevelService.swift
//  edu-app
//
//  Created by Filip Culig on 13.05.2022..
//

import CoreData

// MARK: - LevelService -

class LevelService {
    public var levels: [Level] = []

    init() {}
}

// MARK: - Public methods -

extension LevelService {
    func unlockLevelAfter(_ level: Level, context: NSManagedObjectContext) {
        guard let currentLevelIndex = levels.firstIndex(of: level),
              currentLevelIndex < levels.count - 1 else { return }
        do {
            levels[currentLevelIndex + 1].isLocked = false

            try context.save()
        } catch { print(error) }
    }
}
