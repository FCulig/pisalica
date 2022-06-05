//
//  DrawingCanvasViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 01.04.2022..
//

import Combine
import CoreData
import Foundation
import UIKit

// MARK: - DrawingCanvasViewModel -

class DrawingCanvasViewModel {
    // MARK: - Public properties -

    let level: Level
    var lastPoint: CGPoint!
    var strokeColor: UIColor = .black

    // MARK: - Private properties -

    private let levelService: LevelServiceful
    private let levelValidator: LevelValidatorService = .init()
    private let clearOnCorrect: Bool
    private var points: [CGPoint] = []
    private var currentLetterOfWordIndex = 0
    private lazy var strokeManager = StrokeManager(delegate: self)

    var clearCanvas: AnyPublisher<Void, Never> {
        clearCanvasSubject.eraseToAnyPublisher()
    }

    var clearLastWord: AnyPublisher<Void, Never> {
        clearLastWordSubject.eraseToAnyPublisher()
    }

    var errorNotification: AnyPublisher<Void, Never> {
        errorNotificationSubject.eraseToAnyPublisher()
    }

    var successNotification: AnyPublisher<Void, Never> {
        successNotificationSubject.eraseToAnyPublisher()
    }

    var isAnswerCorrect: AnyPublisher<Bool, Never> {
        isAnswerCorrectSubject.eraseToAnyPublisher()
    }

    // MARK: - Private properties -

    private var clearCanvasSubject: PassthroughSubject<Void, Never> = .init()
    private var clearLastWordSubject: PassthroughSubject<Void, Never> = .init()
    private var errorNotificationSubject: PassthroughSubject<Void, Never> = .init()
    private var successNotificationSubject: PassthroughSubject<Void, Never> = .init()
    private var isAnswerCorrectSubject: PassthroughSubject<Bool, Never> = .init()
    private var cancellabels: Set<AnyCancellable> = []

    // MARK: - Initializer -

    public init(level: Level,
                levelService: LevelServiceful,
                clearOnCorrect: Bool = true)
    {
        self.levelService = levelService
        self.level = level
        self.clearOnCorrect = clearOnCorrect
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

//        successNotificationSubject.send()
//        isAnswerCorrectSubject.send(true)

        if level.isWord {
            // Words
            guard let level = levelService.getLevelForName(level.name?[currentLetterOfWordIndex] ?? ""),
                  points.count == level.numberOfLines * 2 else { return }

            guard levelValidator.isValid(level: level, points: points) else {
                errorNotificationSubject.send()
                isAnswerCorrectSubject.send(false)
                clearInk()
                return
            }

            strokeManager.recognizeInk(level: level, onCompletion: onRecognitionCompleted)
        } else if points.count == level.numberOfLines * 2 {
            // Letters
            guard levelValidator.isValid(level: level, points: points) else {
                errorNotificationSubject.send()
                isAnswerCorrectSubject.send(false)
                clearInk()
                return
            }

            strokeManager.recognizeInk(level: level, onCompletion: onRecognitionCompleted)
        }
    }

    func onRecognitionCompleted(level: Level, result: String?) {
        guard let result = result, let results = level.results else { return }

        if results.contains(result) {
            currentLetterOfWordIndex += 1
            successNotificationSubject.send()
            isAnswerCorrectSubject.send(true)
        } else {
            errorNotificationSubject.send()
            isAnswerCorrectSubject.send(false)
        }

        clearInk()
    }
}

// MARK: - Private methods -

extension DrawingCanvasViewModel {
    func configureLineColor() {
        let lineColor = levelService.getLineColorCode()
        strokeColor = UIColor(hex: lineColor) ?? .black
    }
}

// MARK: - StrokeManagerDelegate -

extension DrawingCanvasViewModel: StrokeManagerDelegate {
    func clearInk() {
        points = []
        strokeManager.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.clearCanvasSubject.send()
        }
    }
}
