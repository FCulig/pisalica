//
//  Background.swift
//  edu-app
//
//  Created by Filip Čulig on 19.11.2023..
//

import SwiftUI

extension View {
    @ViewBuilder var background: some View {
        if isTablet {
            AppImage.houseBackgroundTabletImage.image
                .scaledToFill()
                .ignoresSafeArea()
                .offset(x: 80)
                .blur(radius: 3)
        } else {
            AppImage.houseBackgroundImage.image
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 3)
        }
    }
}
