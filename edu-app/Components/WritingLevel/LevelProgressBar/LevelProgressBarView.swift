//
//  LevelProgressBar.swift
//  edu-app
//
//  Created by Filip Culig on 30.05.2022..
//

import Combine
import SwiftUI

// MARK: - LevelProgressBar -

struct LevelProgressBarView: View {
    // MARK: - Constants -

    var leadingPadding: CGFloat {
        isTablet ? 29 : 13
    }

    var minTrailingPadding: CGFloat {
        isTablet ? 29 : 13
    }

    var maxTrailingPadding: CGFloat {
        isTablet ? 0 : 0
    }

    // MARK: - Private properties -

    private let isTablet = UIDevice.current.localizedModel == "iPad"
    @StateObject private var viewModel: ViewModel
    @State private var didReadSize = false

    // MARK: - Initializer -

    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View components -

    var body: some View {
        ZStack {
            AppImage.levelProgressBar.image
                .overlay(progressIndicator)
                .scaledToFit()
        }
    }

    var progressIndicator: some View {
        ZStack {
            if viewModel.currentProgress > 0 && viewModel.trailingPadding < 480 {
                Rectangle()
                    .cornerRadius(50)
                    .foregroundColor(.init(red: 0.20, green: 0.7, blue: 0.10))
                    .padding(.vertical, isTablet ? 98 : 42)
                    .padding(.leading, leadingPadding)
                    .padding(.bottom, isTablet ? 0 : 1)
                    .padding(.trailing, viewModel.trailingPadding)
            } else if viewModel.currentProgress > 0 {
                Rectangle()
                    .cornerRadius(50)
                    .foregroundColor(.init(red: 0.20, green: 0.7, blue: 0.10))
                    .padding(.vertical, isTablet ? 98 : 42)
                    .padding(.leading, leadingPadding)
                    .padding(.bottom, isTablet ? 0 : 1)
                    .padding(.trailing, 470)
            }
        }
    }
}

struct LevelProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        LevelProgressBarView(viewModel: .init(progressGoal: 10, progress: .init(10)))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        LevelProgressBarView(viewModel: .init(progressGoal: 10, progress: .init(10)))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
