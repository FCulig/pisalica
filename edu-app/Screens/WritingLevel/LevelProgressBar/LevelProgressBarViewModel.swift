//
//  LevelProgressBarViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 31.05.2022..
//

import Combine
import SwiftUI

// MARK: - LevelProgressBarViewModel -

final class LevelProgressBarViewModel : ObservableObject {
    // MARK: - Private properties -

    private let goal: Float
    private let level: Level
    private let currentProgressSubject: AnyPublisher<Float, Never>
    private let currentProgressPercentageSubject: PassthroughSubject<Float, Never> = .init()
    private let guidesButtonTappedSubject: PassthroughSubject<Void, Never> = .init()
    private let outlineButtonEnabledPublisher: AnyPublisher<Bool, Never>
    private let outlineButtonTappedSubject: PassthroughSubject<Void, Never> = .init()
    private let outlineButtonAnimationPublisher: AnyPublisher<Void, Never>
    private let canvasButtonEnabledPublisher: AnyPublisher<Bool, Never>
    private let canvasButtonTappedSubject: PassthroughSubject<Void, Never> = .init()
    private let canvasButtonAnimationPublisher: AnyPublisher<Void, Never>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public properties -
    
    lazy var guidesButtonModel: RoundedButtonViewModel = .init(image: level.guideImage,
                                                               onTap: { [weak self] in self?.guidesButtonTappedSubject.send() })
    
    lazy var outlineButtonModel: RoundedButtonViewModel = .init(image: level.outlineImage, 
                                                                animationViewModel: .init(animationFileName: "tap", triggerPublisher: outlineButtonAnimationPublisher),
                                                                onTap: { [weak self] in self?.outlineButtonTappedSubject.send() })
    
    lazy var canvasButtonModel: RoundedButtonViewModel = .init(animationViewModel: .init(animationFileName: "tap", triggerPublisher: canvasButtonAnimationPublisher),
                                                               onTap: { [weak self] in self?.canvasButtonTappedSubject.send() })
    
    var guidesButtonTapped: AnyPublisher<Void, Never> {
        guidesButtonTappedSubject.eraseToAnyPublisher()
    }
    
    var outlineButtonTapped: AnyPublisher<Void, Never> {
        outlineButtonTappedSubject.eraseToAnyPublisher()
    }
    
    var canvasButtonTapped: AnyPublisher<Void, Never> {
        canvasButtonTappedSubject.eraseToAnyPublisher()
    }
    
    var currentProgressPercentage: AnyPublisher<Float, Never> {
        currentProgressPercentageSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer -

    public init(goal: Float, 
                level: Level,
                currentProgress: AnyPublisher<Float, Never>,
                outlineButtonAnimationPublisher: AnyPublisher<Void, Never>,
                outlineButtonEnabledPublisher: AnyPublisher<Bool, Never>,
                canvasButtonAnimationPublisher: AnyPublisher<Void, Never>,
                canvasButtonEnabledPublisher: AnyPublisher<Bool, Never>) {
        self.goal = goal
        self.level = level
        self.currentProgressSubject = currentProgress
        self.outlineButtonAnimationPublisher = outlineButtonAnimationPublisher
        self.outlineButtonEnabledPublisher = outlineButtonEnabledPublisher
        self.canvasButtonAnimationPublisher = canvasButtonAnimationPublisher
        self.canvasButtonEnabledPublisher = canvasButtonEnabledPublisher
        
        subscribeSubjectChanges()
    }
}

// MARK: - Initial setup -

private extension LevelProgressBarViewModel {
    func subscribeSubjectChanges() {
        currentProgressSubject
            .sink { [weak self] in
                guard let self else { return }
                self.currentProgressPercentageSubject.send($0/self.goal)
            }
            .store(in: &cancellables)
        
        outlineButtonEnabledPublisher
            .map { !$0 }
            .assignWeak(to: \.outlineButtonModel.isLocked, on: self)
            .store(in: &cancellables)
        
        canvasButtonEnabledPublisher
            .map { !$0 }
            .assignWeak(to: \.canvasButtonModel.isLocked, on: self)
            .store(in: &cancellables)
    }
}

// MARK: - Public properties -

extension LevelProgressBarViewModel {
    func tapGuidesButton() {
        guidesButtonTappedSubject.send()
    }
    
    func tapOutlineButton() {
        outlineButtonTappedSubject.send()
    }
    
    func tapCanvasButton() {
        canvasButtonTappedSubject.send()
    }
}
