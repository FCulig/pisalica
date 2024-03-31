//
//  LottieViewModel.swift
//  edu-app
//
//  Created by Filip Čulig on 23.02.2024..
//

import Combine

// MARK: - LottieViewModel -
final class LottieViewModel {
    // MARK: - Public properties -
    
    let animationFileName: String
    var playAnimation: Action?
    
    // MARK: - Private properties -
    
    private let triggerPublisher: AnyPublisher<Void, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializer -
    
    init(animationFileName: String, triggerPublisher: AnyPublisher<Void, Never>) {
        self.animationFileName = animationFileName
        self.triggerPublisher = triggerPublisher
        
        subscribePublishers()
    }
    
    func subscribePublishers() {
        triggerPublisher
            .sink { [weak self] in self?.playAnimation?() }
            .store(in: &cancellables)
    }
}
