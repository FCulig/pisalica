//
//  RoundedButtonModel.swift
//  edu-app
//
//  Created by Filip Čulig on 31.03.2024..
//

import SwiftUI

// MARK: - RoundedButtonViewModel -
final class RoundedButtonViewModel: ObservableObject {
    // MARK: - Public properties -
    
    let image: String?
    let animationViewModel: LottieViewModel?
    @Published var isLocked = false
    
    // MARK: - Private properties -
    
    private let onTap: Action?
    
    // MARK: - Initializer -
    
    init(image: String? = nil,
         animationViewModel: LottieViewModel? = nil,
         onTap: Action? = nil) {
        self.image = image
        self.animationViewModel = animationViewModel
        self.onTap = onTap
    }
}

// MARK: - Public methods -

extension RoundedButtonViewModel {
    func onTapGesture() {
        onTap?()
    }
}
