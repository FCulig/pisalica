//
//  AppImage.swift
//  edu-app
//
//  Created by Filip Culig on 05.03.2022..
//

import Foundation
import SwiftUI

enum AppImage {
    case panelBackgroundImage
    case houseBackgroundImage
    case drawingPanelBackgroundImage
    case videoPanelBackgroundImage
    case textButtonBackground
    case textButtonPressedBackground
    case titleSignBackground
    case trashCanButton
    case playButton
    case previousButton
    case nextButton
    case helpButton
    case videoButton
    case shopButton

    var image: Image {
        switch self {
        case .panelBackgroundImage:
            return Image("panel-background").resizable()
        case .houseBackgroundImage:
            return Image("house-background").resizable()
        case .drawingPanelBackgroundImage:
            return Image("drawing-panel-background").resizable()
        case .videoPanelBackgroundImage:
            return Image("video-panel-background").resizable()
        case .textButtonBackground:
            return Image("text-button-background").resizable()
        case .textButtonPressedBackground:
            return Image("text-button-pressed-background").resizable()
        case .titleSignBackground:
            return Image("title-sign-background").resizable()
        case .trashCanButton:
            return Image("trash-can-button").resizable()
        case .playButton:
            return Image("play-button").resizable()
        case .previousButton:
            return Image("previous-button").resizable()
        case .nextButton:
            return Image("next-button").resizable()
        case .helpButton:
            return Image("help-button").resizable()
        case .videoButton:
            return Image("video-button").resizable()
        case .shopButton:
            return Image("shop-button").resizable()
        }
    }
}
