//
//  Levels.swift
//  edu-app
//
//  Created by Filip Culig on 02.04.2022..
//

import Foundation

enum Level {
    case A
    case B
    case C
    case D

    var results: [String] {
        switch self {
        case .A:
            return ["A"]
        case .B:
            return ["B"]
        case .C:
            return ["C", "c"]
        case .D:
            return ["D"]
        }
    }

    var numberOfLines: Int {
        switch self {
        case .A:
            return 3
        case .B:
            return 3
        case .C:
            return 1
        case .D:
            return 2
        }
    }

    var rawName: String {
        switch self {
        case .A:
            return "A"
        case .B:
            return "B"
        case .C:
            return "C"
        case .D:
            return "D"
        }
    }
}
