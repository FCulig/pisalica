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

    var level: Level
    var lastPoint: CGPoint!
    var strokeColor: UIColor = .black
    var recognizedLetterIndexes: [Int] = []

    var onWordCorrectWithHints: PassthroughSubject<Void, Never>?

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

    var onWordCorrect: AnyPublisher<Void, Never> {
        onWordCorrectSubject.eraseToAnyPublisher()
    }

    // MARK: - Private properties -

    private let levelService: LevelServiceful
    private let levelValidator: LevelValidatorService = .init()
    private var points: [CGPoint] = []
    private lazy var strokeManager = StrokeManager(delegate: self)

    private var clearCanvasSubject: PassthroughSubject<Void, Never> = .init()
    private var clearLastWordSubject: PassthroughSubject<Void, Never> = .init()
    private var errorNotificationSubject: PassthroughSubject<Void, Never> = .init()
    private var successNotificationSubject: PassthroughSubject<Void, Never> = .init()
    private var isAnswerCorrectSubject: PassthroughSubject<Bool, Never> = .init()
    private var onWordCorrectSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellabels: Set<AnyCancellable> = []

    // MARK: - Initializer -

    public init(level: Level,
                levelService: LevelServiceful,
                onWordCorrectWithHints: PassthroughSubject<Void, Never>? = nil)
    {
        self.levelService = levelService
        self.level = level
        self.onWordCorrectWithHints = onWordCorrectWithHints

        subscribeActions()
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
//
//        return

        let isValid = levelValidator.isValid(level: level, points: points)

        guard isValid else {
            errorNotificationSubject.send()
            isAnswerCorrectSubject.send(false)
            clearInk()
            return
        }

        // If all lines are drawn and correct, OCR the ink
        if points.count == level.numberOfLines * 2 {
            strokeManager.recognizeInk(level: level, letterIndex: 0, onCompletion: onRecognitionCompleted)
        } else {
            // If all lines are not drawn, line is valid, so show success
            successNotificationSubject.send()
        }

        return
        if level.isWord {
            var currentLetterOfWordIndex: Int?
            for i in 0 ..< (level.name?.count ?? 0) {
                if currentLetterOfWordIndex == nil,
                   !recognizedLetterIndexes.contains(i)
                {
                    currentLetterOfWordIndex = i
                }
            }

            // Words
            guard let currentLetterOfWordIndex = currentLetterOfWordIndex,
                  let level = levelService.getLevelForName(level.name?[currentLetterOfWordIndex] ?? ""),
                  points.count == level.numberOfLines * 2 else { return }

            guard levelValidator.isValid(level: level, points: points) else {
                errorNotificationSubject.send()
                isAnswerCorrectSubject.send(false)
                clearInk()
                return
            }

            strokeManager.recognizeInk(level: level, letterIndex: currentLetterOfWordIndex, onCompletion: onRecognitionCompleted)
        } else if points.count == level.numberOfLines * 2 {
            // Letters
            guard levelValidator.isValid(level: level, points: points) else {
                errorNotificationSubject.send()
                isAnswerCorrectSubject.send(false)
                clearInk()
                return
            }

            strokeManager.recognizeInk(level: level, letterIndex: 0, onCompletion: onRecognitionCompleted)
        }
    }

    func onRecognitionCompleted(level: Level, letterIndex: Int, result: String?) {
        guard let result = result, let results = level.results else { return }

        if results.contains(result) {
            successNotificationSubject.send()
            isAnswerCorrectSubject.send(true)
            recognizedLetterIndexes.append(letterIndex)

            if self.level.isWord, recognizedLetterIndexes.count == (self.level.name?.count ?? -1) {
                recognizedLetterIndexes = []
                clearInk()
                onWordCorrectSubject.send()
            }
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

    func subscribeActions() {
        onWordCorrectWithHints?
            .sink { [weak self] in
                guard let self = self else { return }
                self.recognizedLetterIndexes = []
                self.clearInk()
                self.onWordCorrectSubject.send()
                print("TU")
            }
            .store(in: &cancellabels)
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
