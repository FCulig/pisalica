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
    // MARK: - Private properties -

    @ObservedObject private var viewModel: ViewModel

    // MARK: - Initializer -

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View components -

    var body: some View {
        outline
    }
}

// MARK: - Progress bar components -

private extension LevelProgressBarView {
    var outline: some View {
        GeometryReader { reader in
            Capsule()
                .strokeBorder(AppColor.brownBorder.color, style: StrokeStyle(lineWidth: 15))
                .overlay(progressIndicator)
                .overlay(checkpoints)
                .onAppear {
                    viewModel.progressBarWidth = reader.frame(in: .global).width
                    viewModel.updateView()
                }
        }
    }
    
    var progressIndicator: some View {
        Capsule()
            .fill(AppColor.green.color)
            .frame(width: viewModel.progressIndicatorWidth)
            .padding(5)
    }
}

// MARK: - Progress checkpoints -

private extension LevelProgressBarView {
    var checkpoints: some View {
        // TODO: Replace rectangles with images
        HStack(spacing: 0) {
            Rectangle()
                .fill(AppColor.brownBorder.color)
                .frame(width: 1)
                .padding(.trailing, viewModel.checkpointSpacing)
            
            Rectangle()
                .fill(AppColor.brownBorder.color)
                .frame(width: 1)
                .padding(.trailing, viewModel.checkpointSpacing)
            
            Rectangle()
                .fill(AppColor.brownBorder.color)
                .frame(width: 1)
            
            Spacer()
        }
    }
}

// MARK: - Previews -

struct LevelProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        LevelProgressBarView(viewModel: .init(goal: 10, currentProgress: Just(4).eraseToAnyPublisher()))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

//        LevelProgressBarView(viewModel: .init())
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDevice("iPad Air (5th generation)")
    }
}
