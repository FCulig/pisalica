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
    
    @ObservedObject private var model: RoundedButtonViewModel

    // MARK: - Initializer -

    public init(model: RoundedButtonViewModel) {
        self.model = model
    }

    // MARK: - View components -

    var body: some View {
        ZStack {
            AppImage.emptyButton.image
                .scaledToFit()

            if let buttonImage = model.image {
                Image(buttonImage)
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, isTablet ? 13 : 7)
                    .padding(.all, 7)
            } else {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: isTablet ? 30 : 22, height: isTablet ? 30 : 22)
                    .padding(.bottom, isTablet ? 13 : 7)
                    .padding(.all, 7)
            }

            if model.isLocked {
                lockedOverlay
            }
        }
        .onTapGesture { model.onTapGesture() }
        .allowsHitTesting(!model.isLocked)
        .overlay(animationOverlay)
    }

    private var lockedOverlay: some View {
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
    
    @ViewBuilder private var animationOverlay: some View {
        if let animationViewModel = model.animationViewModel {
            LottieView(viewModel: animationViewModel)
                .padding(.leading, 25)
                .padding(.top, 5)
                .allowsHitTesting(false)
           }
    }
}

// MARK: - Previews -

//struct RoundedButton_Previews: PreviewProvider {
//    static var previews: some View {
//        RoundedButton(buttonImage: Image("A-guide"))
//            .frame(width: 55)
//
//        RoundedButton(buttonImage: Image("A-guide"), isLocked: .constant(true))
//            .frame(width: 55)
//    }
//}
