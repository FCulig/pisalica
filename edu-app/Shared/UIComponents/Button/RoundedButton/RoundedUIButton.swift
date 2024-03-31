//
//  RoundedUIButton.swift
//  edu-app
//
//  Created by Filip Čulig on 24.02.2024..
//

import Combine
import SwiftUI

// MARK: - RoundedUIButton -
final class RoundedUIButton: UIHostingController<RoundedButton> {
    // MARK: - Initializer -
    
    init(model: RoundedButtonViewModel) {
        super.init(rootView: RoundedButton(model: model))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
                   
    // MARK: - Lifecycle -
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .clear
    }
}
