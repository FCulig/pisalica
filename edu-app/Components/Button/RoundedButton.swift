//
//  RoundedButton.swift
//  edu-app
//
//  Created by Filip Culig on 02.06.2022..
//

import SwiftUI

// MARK: - RoundedButton -

struct RoundedButton: View {
    // MARK: - Private properties -

    private let isTablet = UIDevice.current.localizedModel == "iPad"
    private let buttonImage: Image?

    // MARK: - Public properties -

    @State var isLocked: Bool

    // MARK: - Initializer -

    public init(buttonImage: Image? = nil, isLocked: Bool) {
        self.buttonImage = buttonImage
        self.isLocked = isLocked
    }

    // MARK: - View components -

    var body: some View {
        ZStack {
            AppImage.emptyButton.image
                .scaledToFit()

            if let buttonImage = buttonImage {
                buttonImage
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, isTablet ? 0 : 7)
                    .padding(.all, 7)
            } else {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 22, height: 22)
                    .padding(.bottom, isTablet ? 0 : 7)
                    .padding(.all, 7)
            }

            if isLocked {
                lockedOverlay
            }
        }
    }

    var lockedOverlay: some View {
        ZStack {
            // Brown overlay
            AppImage.emptyButtonLockedOverlay.image
                .scaledToFit()
                .opacity(0.51)

            // Lock
            AppImage.lock.image
                .scaledToFit()
                .rotationEffect(.degrees(-35))
                .frame(width: 25)
                .padding(.top, 30)
                .padding(.leading, 30)
        }
    }
}

// MARK: - Previews -

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(buttonImage: Image("A-guide"), isLocked: false)
            .frame(width: 55)

        RoundedButton(buttonImage: Image("A-guide"), isLocked: true)
            .frame(width: 55)
    }
}
