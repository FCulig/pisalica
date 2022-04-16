//
//  AppImage.swift
//  edu-app
//
//  Created by Filip Culig on 05.03.2022..
//

import Foundation
import SwiftUI

enum AppImage {
    case houseBackgroundImage
    case textButtonBackground
    case textButtonPressedBackground
    case titleSignBackground
    case trashCanButton
    case playButton

    var image: Image {
        switch self {
        case .houseBackgroundImage:
            return Image("house-background")
        case .textButtonBackground:
            return Image("text-button-background")
        case .textButtonPressedBackground:
            return Image("text-button-pressed-background")
        case .titleSignBackground:
            return Image("title-sign-background")
        case .trashCanButton:
            return Image("trash-can-button")
        case .playButton:
            return Image("play-button")
        }
    }
}
