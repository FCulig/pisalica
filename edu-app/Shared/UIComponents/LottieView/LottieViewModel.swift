//
//  LottieViewModel.swift
//  edu-app
//
//  Created by Filip Čulig on 23.02.2024..
//

import Combine
import Lottie

// MARK: - LottieViewModel -
final class LottieViewModel {
    // MARK: - Public properties -
    
    let animationFileName: String
    let loopMode: LottieLoopMode
    var playAnimation: Action?
    
    // MARK: - Private properties -
    
    private let triggerPublisher: AnyPublisher<Void, Never>?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializer -
    
    init(animationFileName: String,
         loopMode: LottieLoopMode = .loop,
         triggerPublisher: AnyPublisher<Void, Never>? = nil) {
        self.animationFileName = animationFileName
        self.loopMode = loopMode
        self.triggerPublisher = triggerPublisher
        
        if triggerPublisher != nil {
            subscribePublishers()
        } else {
            playAnimation?()
        }
    }
    
    func subscribePublishers() {
        triggerPublisher?
            .sink { [weak self] in self?.playAnimation?() }
            .store(in: &cancellables)
    }
}
