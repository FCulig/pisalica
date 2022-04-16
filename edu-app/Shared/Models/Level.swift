//
//  Level.swift
//  edu-app
//
//  Created by Filip Culig on 16.04.2022..
//

import Foundation

struct Level: Identifiable, Hashable {
    let id: UUID = .init()
    let isLocked: Bool
    let level: Levels
}
