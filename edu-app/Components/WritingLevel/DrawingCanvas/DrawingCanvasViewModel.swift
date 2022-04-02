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
    // MARK: - Private properties -

    public lazy var strokeManager = StrokeManager(delegate: self)

    private var clearCanvasSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellabels: Set<AnyCancellable> = []

    // MARK: - Public properties -

    var lastPoint: CGPoint!

    var clearCanvas: AnyPublisher<Void, Never> {
        clearCanvasSubject.eraseToAnyPublisher()
    }

    let clearCanvasAction: PassthroughSubject<Void, Never> = .init()

    // MARK: - Initializer

    public init() {
        subscribeActions()

        strokeManager.selectLanguage(languageTag: "hr")
    }

    private func subscribeActions() {
        clearCanvasAction
            .sink { [weak self] in
                guard let self = self else { return }
                self.clearCanvasSubject.send()
                self.strokeManager.clear()
            }
            .store(in: &cancellabels)
    }
}

// MARK: - Touch lifecycle -

extension DrawingCanvasViewModel {
    func touchesBegan(touchPoint: CGPoint, time: TimeInterval) {
        lastPoint = touchPoint
        strokeManager.startStrokeAtPoint(point: touchPoint, t: time)
    }

    func touchesMoved(time: TimeInterval) {
        strokeManager.continueStrokeAtPoint(point: lastPoint, t: time)
    }

    func touchesEnded(time: TimeInterval) {
        strokeManager.endStrokeAtPoint(point: lastPoint, t: time)
    }
}

// MARK: - StrokeManagerDelegate -

extension DrawingCanvasViewModel: StrokeManagerDelegate {
    // TODO: Mozda neki delay?
    func clearInk() {
        clearCanvasSubject.send()
    }
}
