//
//  ProgressBar.swift
//  edu-app
//
//  Created by Filip Culig on 08.05.2022..
//

import SwiftUI

// MARK: - ProgressBar -

struct ProgressBar: View {
    @State var progressBarFrame: CGSize = .zero
    @State var currentValue: Float
    @State var maxValue: Float

    public init(currentValue: Float, maxValue: Float) {
        self.currentValue = currentValue
        self.maxValue = maxValue
    }

    // MARK: - View components -

    var body: some View {
        VStack(spacing: 0) {
            progressText
            progressIndicator
        }
    }

    var progressText: some View {
        Text("\(Int(currentValue)) / \(Int(maxValue))")
            .foregroundColor(.white)
            .shadow(color: .black, radius: 0, x: 3, y: 2)
            .font(.system(size: 20).weight(.bold))
    }

    var progressIndicator: some View {
        ZStack {
            AppImage.progressBarBackground.image
                .scaledToFit()
            GeometryReader { geometry in
                self.makeProgressBarIndicator(geometry)
            }
        }
    }
}

// MARK: - Helper methods -

private extension ProgressBar {
    func makeProgressBarIndicator(_ geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async { self.progressBarFrame = geometry.size }
        let indicatorWidth = geometry.size.width * CGFloat(currentValue / maxValue)

        return AppImage.progressBarIndicator.image
            .padding(.vertical, 14)
            .padding(.horizontal, 3)
            .frame(width: indicatorWidth)
    }
}

// MARK: - Preview -

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(currentValue: 3, maxValue: 10)
    }
}
