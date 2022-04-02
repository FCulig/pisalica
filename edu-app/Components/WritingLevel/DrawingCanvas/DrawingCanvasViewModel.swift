//
//  DrawingCanvasViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 01.04.2022..
//

import Combine
import Foundation
import UIKit

// MARK: - DrawingCanvasViewModel -

class DrawingCanvasViewModel {
    // MARK: - Public properties -

    let level: Level
    let levelValidator: LevelValidatorService
    var lastPoint: CGPoint!
    var points: [CGPoint] = []
    lazy var strokeManager = StrokeManager(delegate: self)

    var clearCanvas: AnyPublisher<Void, Never> {
        clearCanvasSubject.eraseToAnyPublisher()
    }

    let clearCanvasAction: PassthroughSubject<Void, Never> = .init()

    // MARK: - Private properties -

    private var clearCanvasSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellabels: Set<AnyCancellable> = []

    // MARK: - Initializer

    public init(level: Level, levelValidatorService: LevelValidatorService) {
        self.level = level
        levelValidator = levelValidatorService

        subscribeActions()
        strokeManager.selectLanguage(languageTag: "hr")
    }

    private func subscribeActions() {
        clearCanvasAction
            .sink { [weak self] in
                guard let self = self else { return }
                self.clearCanvasSubject.send()
                self.strokeManager.clear()
                self.points = []
            }
            .store(in: &cancellabels)
    }
}

// MARK: - Touch lifecycle -

extension DrawingCanvasViewModel {
    func touchesBegan(touchPoint: CGPoint, time: TimeInterval) {
        lastPoint = touchPoint
        strokeManager.startStrokeAtPoint(point: lastPoint, t: time)
        points.append(lastPoint)
    }

    func touchesMoved(time: TimeInterval) {
        strokeManager.continueStrokeAtPoint(point: lastPoint, t: time)
    }

    func touchesEnded(time: TimeInterval) {
        strokeManager.endStrokeAtPoint(point: lastPoint, t: time)
        points.append(lastPoint)

        if points.count == level.numberOfLines * 2,
           levelValidator.isValid(level: level, points: points)
        {
            print("Now we should validate")
            strokeManager.recognizeInk()
        } else {
            print("Invalid")
        }
    }
}

// MARK: - StrokeManagerDelegate -

extension DrawingCanvasViewModel: StrokeManagerDelegate {
    // TODO: Mozda neki delay?
    func clearInk() {
        clearCanvasSubject.send()
    }
}
