//
//  ProgressBar.swift
//  edu-app
//
//  Created by Filip Culig on 08.05.2022..
//

import SwiftUI

// MARK: - ProgressBar -

struct ProgressBar: View {
    // MARK: - Private properties -

    private let isTablet = UIDevice.current.localizedModel == "iPad"

    // MARK: - Public properties -

    @State var progressBarFrame: CGSize = .zero
    @State var currentValue: Float
    @State var maxValue: Float

    // MARK: - Initializer -

    public init(currentValue: Float, maxValue: Float) {
        self.currentValue = currentValue
        self.maxValue = maxValue
    }

    // MARK: - View components -

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            progressText
            progressIndicator
            Spacer()
        }
    }

    var progressText: some View {
        Text("\(Int(currentValue)) / \(Int(maxValue))")
            .foregroundColor(.white)
            .shadow(color: .black, radius: 0, x: 3, y: 2)
            .font(.system(size: isTablet ? 25 : 20).weight(.bold))
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
        var indicatorWidth: CGFloat = isTablet ? 23 : 10

        if geometry.size.width * CGFloat(currentValue / maxValue) > indicatorWidth {
            indicatorWidth = geometry.size.width * CGFloat(currentValue / maxValue)
        } else if currentValue == 0 {
            indicatorWidth = 0
        }

        return Rectangle()
            .cornerRadius(20)
            .foregroundColor(.init(red: 0.20, green: 0.7, blue: 0.10))
            .padding(.vertical, isTablet ? 25 : 5)
            .padding(.horizontal, 3)
            .frame(width: indicatorWidth)
    }
}

// MARK: - Preview -

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(currentValue: 3, maxValue: 10)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        ProgressBar(currentValue: 3, maxValue: 10)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
