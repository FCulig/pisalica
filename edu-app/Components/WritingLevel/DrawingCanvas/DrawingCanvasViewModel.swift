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

    private let levelValidator: LevelValidatorService = .init()
    private var points: [CGPoint] = []
    private lazy var strokeManager = StrokeManager(delegate: self)

    var clearCanvas: AnyPublisher<Void, Never> {
        clearCanvasSubject.eraseToAnyPublisher()
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
    private var errorNotificationSubject: PassthroughSubject<Void, Never> = .init()
    private var successNotificationSubject: PassthroughSubject<Void, Never> = .init()
    private var isAnswerCorrectSubject: PassthroughSubject<Bool, Never> = .init()
    private var cancellabels: Set<AnyCancellable> = []

    // MARK: - Initializer

    public init(level: Level) {
        self.level = level
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

        if points.count == level.numberOfLines * 2 {
            guard levelValidator.isValid(level: level, points: points) else {
                errorNotificationSubject.send()
                isAnswerCorrectSubject.send(false)
                clearInk()
                return
            }

            strokeManager.recognizeInk(onCompletion: onRecognitionCompleted)
        }
    }

    func onRecognitionCompleted(result: String?) {
        guard let result = result, let results = level.results else { return }

        if results.contains(result) {
            successNotificationSubject.send()
            isAnswerCorrectSubject.send(true)
        } else {
            errorNotificationSubject.send()
            isAnswerCorrectSubject.send(false)
        }
    }
}

// MARK: - Private methods -

extension DrawingCanvasViewModel {
    func configureLineColor(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ShopItem> = ShopItem.fetchRequest()
        do {
            let shopItems = try context.fetch(fetchRequest)
            shopItems.forEach { item in
                guard item.isSelected else { return }
                strokeColor = UIColor(hex: item.hexColor ?? "#121212") ?? .black
            }

        } catch { print(error) }
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
