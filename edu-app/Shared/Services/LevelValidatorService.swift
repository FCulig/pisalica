//
//  LevelValidatorService.swift
//  edu-app
//
//  Created by Filip Culig on 02.04.2022..
//

import Foundation
import UIKit

// MARK: - LevelValidatorService -

class LevelValidatorService {
    public init() {}

    func isValid(level: Level, points: [CGPoint]) -> Bool {
        switch level {
        case .A:
            return validateA(points: points)
        case .B:
            return true
        case .C:
            return true
        case .D:
            return true
        }
    }
}

private extension LevelValidatorService {
    private func validateA(points: [CGPoint]) -> Bool {
        return points[0].x > points[1].x && points[2].x < points[3].x && areClose(firstPoint: points[0], secondPoint: points[2])
            && points[0].y < points[1].y && points[2].y < points[3].y && points[4].y < points[1].y && areCloseYAxis(firstPoint: points[4], secondPoint: points[5])
    }
}

// MARK: - Utilities -

private extension LevelValidatorService {
    func areClose(firstPoint: CGPoint, secondPoint: CGPoint) -> Bool {
        return areCloseYAxis(firstPoint: firstPoint, secondPoint: secondPoint) && areCloseXAxis(firstPoint: firstPoint, secondPoint: secondPoint)
    }

    func areCloseYAxis(firstPoint: CGPoint, secondPoint: CGPoint) -> Bool {
        return abs(firstPoint.y - secondPoint.y) < 10
    }

    func areCloseXAxis(firstPoint: CGPoint, secondPoint: CGPoint) -> Bool {
        return abs(firstPoint.x - secondPoint.x) < 10
    }
}
