//
//  AppImage.swift
//  edu-app
//
//  Created by Filip Culig on 05.03.2022..
//

import Foundation
import SwiftUI

enum AppImage {
    case textButtonBackground
    case textButtonPressedBackground
    case titleSignBackground

    var image: Image {
        switch self {
        case .textButtonBackground:
            return Image("text-button-background")
        case .textButtonPressedBackground:
            return Image("text-button-pressed-background")
        case .titleSignBackground:
            return Image("title-sign-background")
        }
    }
}
