//
//  LevelValidatorService.swift
//  edu-app
//
//  Created by Filip Culig on 02.04.2022..
//

import Foundation
import UIKit

// MARK: - LevelValidatorService -

final class LevelValidatorService {
    public init() {}

    func isValid(level: Level, points: [CGPoint]) -> Bool {
        if level.name == "A" {
            return validateA(points: points)
        } else if level.name == "B" {
            return validateB(points: points)
        } else if level.name == "C" {
            return validateC(points: points)
        } else if level.name == "Č" {
            return validateTvrdoC(points: points)
        } else if level.name == "Ć" {
            return validateMekoC(points: points)
        } else if level.name == "D" {
            return validateD(points: points)
        } else if level.name == "Đ" {
            return validateMekoD(points: points)
        } else if level.name == "DŽ" {
            return validateDZ(points: points)
        } else if level.name == "E" {
            return validateE(points: points)
        } else if level.name == "F" {
            return validateF(points: points)
        } else if level.name == "G" {
            return validateG(points: points)
        } else if level.name == "H" {
            return validateH(points: points)
        } else if level.name == "I" {
            return validateI(points: points)
        } else if level.name == "J" {
            return validateJ(points: points)
        } else if level.name == "K" {
            return validateK(points: points)
        } else if level.name == "L" {
            return validateL(points: points)
        } else if level.name == "LJ" {
            return validateLJ(points: points)
        } else if level.name == "M" {
            return validateM(points: points)
        } else if level.name == "N" {
            return validateN(points: points)
        } else if level.name == "NJ" {
            return validateNJ(points: points)
        } else if level.name == "O" {
            return validateO(points: points)
        } else if level.name == "P" {
            return validateP(points: points)
        } else if level.name == "R" {
            return validateR(points: points)
        } else if level.name == "S" {
            return validateS(points: points)
        } else if level.name == "Š" {
            return validateSh(points: points)
        } else if level.name == "T" {
            return validateT(points: points)
        } else if level.name == "U" {
            return validateU(points: points)
        } else if level.name == "V" {
            return validateV(points: points)
        } else if level.name == "Z" {
            return validateZ(points: points)
        } else if level.name == "Ž" {
            return validateZh(points: points)
        }

        return false
    }
}

// MARK: - Validating capital letters -

private extension LevelValidatorService {
    func validateA(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = points[0].x > points[1].x && points[0].y < points[1].y

        guard points.count >= 4, currentValidationResult else { return currentValidationResult }
        currentValidationResult = points[2].x < points[3].x && points[2].y < points[3].y && areClose(firstPoint: points[0], secondPoint: points[2])

        guard points.count == 6, currentValidationResult else { return currentValidationResult }
        return points[4].y < points[1].y && areCloseYAxis(firstPoint: points[4], secondPoint: points[5]) && points[4].x < points[5].x
    }

    func validateB(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = points[0].y < points[1].y && areCloseXAxis(firstPoint: points[0], secondPoint: points[1])

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = areClose(firstPoint: points[0], secondPoint: points[2])

        guard points.count >= 6 else { return currentValidationResult }
        return areClose(firstPoint: points[3], secondPoint: points[4]) && areClose(firstPoint: points[1], secondPoint: points[5])
    }

    func validateC(points: [CGPoint]) -> Bool {
        guard points.count >= 2 else { return false }
        return points[0].y < points[1].y && areCloseXAxis(firstPoint: points[0], secondPoint: points[1])
    }

    func validateMekoC(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateC(points: [points[0], points[1]])

        guard points.count >= 4 else { return currentValidationResult }
        return points[2].x < points[3].x && points[2].y > points[3].y
    }

    func validateTvrdoC(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateC(points: [points[0], points[1]])

        guard points.count >= 4 else { return currentValidationResult }
        return areCloseYAxis(firstPoint: points[2], secondPoint: points[3]) && points[2].x < points[3].x
    }

    func validateD(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1])

        guard points.count >= 4 else { return currentValidationResult }
        return areCloseXAxis(firstPoint: points[2], secondPoint: points[3]) &&
            areClose(firstPoint: points[0], secondPoint: points[2]) &&
            areClose(firstPoint: points[1], secondPoint: points[3])
    }

    func validateMekoD(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateD(points: points)

        guard points.count >= 6 else { return currentValidationResult }
        return areCloseYAxis(firstPoint: points[4], secondPoint: points[5]) && points[4].x < points[5].x
    }

    func validateDZ(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateD(points: points)

        guard points.count >= 6 else { return currentValidationResult }
        return validateZh(points: Array(points[4 ..< points.count]))
    }

    func validateE(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[0].y < points[1].y

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = areClose(firstPoint: points[0], secondPoint: points[2]) && points[2].x < points[3].x && areCloseYAxis(firstPoint: points[2], secondPoint: points[3])

        guard points.count >= 6 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[2], secondPoint: points[4]) && points[4].x < points[5].x && areCloseYAxis(firstPoint: points[4], secondPoint: points[5])

        guard points.count >= 8 else { return currentValidationResult }
        return areClose(firstPoint: points[6], secondPoint: points[1]) && areCloseYAxis(firstPoint: points[6], secondPoint: points[7]) && points[6].x < points[7].x
    }

    func validateF(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[0].y < points[1].y

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = areClose(firstPoint: points[0], secondPoint: points[2]) && points[2].x < points[3].x && areCloseYAxis(firstPoint: points[2], secondPoint: points[3])

        guard points.count >= 6 else { return currentValidationResult }
        return areCloseXAxis(firstPoint: points[2], secondPoint: points[4]) && points[4].x < points[5].x && areCloseYAxis(firstPoint: points[4], secondPoint: points[5])
    }

    func validateG(points: [CGPoint]) -> Bool {
        guard points.count >= 2 else { return false }
        return points[0].x > points[1].x && points[0].y < points[1].y
    }

    func validateH(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[1].y > points[0].y

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[2], secondPoint: points[3]) && points[2].y < points[3].y

        guard points.count >= 6 else { return currentValidationResult }
        return areCloseYAxis(firstPoint: points[4], secondPoint: points[5]) && points[4].x < points[5].x
    }

    func validateI(points: [CGPoint]) -> Bool {
        return areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[1].y > points[0].y
    }

    func validateJ(points: [CGPoint]) -> Bool {
        return points[0].x > points[1].x && points[0].y < points[1].y
    }

    func validateK(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[1].y > points[0].y

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = points[2].x < points[3].x && points[2].y > points[3].y

        guard points.count >= 6 else { return currentValidationResult }
        return points[4].x < points[5].x && points[4].y < points[5].y
    }

    func validateL(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[1].y > points[0].y

        guard points.count >= 4 else { return currentValidationResult }
        return points[2].x < points[3].x && areClose(firstPoint: points[1], secondPoint: points[2]) && areCloseYAxis(firstPoint: points[2], secondPoint: points[3])
    }

    func validateLJ(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateL(points: points)

        guard points.count >= 6 else { return currentValidationResult }
        return validateJ(points: [points[4], points[5]])
    }

    func validateM(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[1].y > points[0].y

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = areClose(firstPoint: points[0], secondPoint: points[2])

        guard points.count >= 6 else { return currentValidationResult }
        return areCloseXAxis(firstPoint: points[4], secondPoint: points[5]) && points[4].y < points[5].y && areClose(firstPoint: points[3], secondPoint: points[4])
    }

    func validateN(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[1].y > points[0].y

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = areClose(firstPoint: points[0], secondPoint: points[2])

        guard points.count >= 6 else { return currentValidationResult }
        return areCloseXAxis(firstPoint: points[4], secondPoint: points[5]) && points[4].y > points[5].y && areClose(firstPoint: points[3], secondPoint: points[4])
    }

    func validateNJ(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateN(points: points)

        guard points.count >= 8 else { return currentValidationResult }
        return validateJ(points: [points[6], points[7]])
    }

    func validateO(points: [CGPoint]) -> Bool {
        return areClose(firstPoint: points[0], secondPoint: points[1])
    }

    func validateP(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[1].y > points[0].y

        guard points.count >= 4 else { return currentValidationResult }
        return areClose(firstPoint: points[0], secondPoint: points[2])
    }

    func validateR(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateP(points: points)

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = validateP(points: points)

        guard points.count >= 6 else { return currentValidationResult }
        return points[4].x < points[5].x && points[4].y < points[5].y
    }

    func validateS(points: [CGPoint]) -> Bool {
        return points[0].x > points[1].x && points[0].y < points[1].y
    }

    func validateSh(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateS(points: points)

        guard points.count >= 4 else { return currentValidationResult }
        return areCloseYAxis(firstPoint: points[2], secondPoint: points[3]) && points[2].x < points[3].x
    }

    func validateT(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseXAxis(firstPoint: points[0], secondPoint: points[1]) && points[1].y > points[0].y

        guard points.count >= 4 else { return currentValidationResult }
        return points[2].x < points[3].x && areCloseYAxis(firstPoint: points[2], secondPoint: points[3])
    }

    func validateU(points: [CGPoint]) -> Bool {
        return areCloseYAxis(firstPoint: points[0], secondPoint: points[1]) && points[0].x < points[1].x
    }

    func validateV(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = points[0].y < points[1].y

        guard points.count >= 4 else { return currentValidationResult }
        return areCloseYAxis(firstPoint: points[0], secondPoint: points[2]) && areClose(firstPoint: points[1], secondPoint: points[3]) && points[2].y < points[3].y
    }

    func validateZ(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = areCloseYAxis(firstPoint: points[0], secondPoint: points[1])

        guard points.count >= 4 else { return currentValidationResult }
        currentValidationResult = areClose(firstPoint: points[1], secondPoint: points[2])

        guard points.count >= 6 else { return currentValidationResult }
        return areClose(firstPoint: points[3], secondPoint: points[4])
    }

    func validateZh(points: [CGPoint]) -> Bool {
        var currentValidationResult = false

        guard points.count >= 2 else { return currentValidationResult }
        currentValidationResult = validateZ(points: points)

        guard points.count >= 8 else { return currentValidationResult }
        return areCloseYAxis(firstPoint: points[6], secondPoint: points[7]) && points[6].x < points[7].x
    }
}

// MARK: - Utilities -

private extension LevelValidatorService {
    func areClose(firstPoint: CGPoint, secondPoint: CGPoint) -> Bool {
        return areCloseYAxis(firstPoint: firstPoint, secondPoint: secondPoint) && areCloseXAxis(firstPoint: firstPoint, secondPoint: secondPoint)
    }

    func areCloseYAxis(firstPoint: CGPoint, secondPoint: CGPoint) -> Bool {
        return abs(firstPoint.y - secondPoint.y) < 15
    }

    func areCloseXAxis(firstPoint: CGPoint, secondPoint: CGPoint) -> Bool {
        return abs(firstPoint.x - secondPoint.x) < 15
    }
}
