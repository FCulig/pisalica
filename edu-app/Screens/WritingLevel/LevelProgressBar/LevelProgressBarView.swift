//
//  LevelProgressBar.swift
//  edu-app
//
//  Created by Filip Culig on 30.05.2022..
//

import Combine
import SwiftUI

// MARK: - LevelProgressBar -

struct LevelProgressBarView: UIViewRepresentable {
    let viewModel: LevelProgressBarViewModel
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    func makeUIView(context: Context) -> UIView {
        LevelProgressBarUIView(viewModel: viewModel)
    }
}
