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
    case drawingPanelTutorialBackgroundImage
    case videoPanelBackgroundImage
    case textButtonBackground
    case textButtonPressedBackground
    case titleSignBackground
    case wordsButton
    case lettersButton
    case trashCanButton
    case previousButton
    case nextButton
    case helpButton
    case videoButton
    case shopButton
    case achievementsButton
    case achievementItemBackground
    case progressBarBackground
    case progressBarIndicator
    case goldMedal
    case silverMedal
    case ribbon

    var image: Image {
        switch self {
        case .panelBackgroundImage:
            return Image("panel-background").resizable()
        case .houseBackgroundImage:
            return Image("house-background").resizable()
        case .drawingPanelBackgroundImage:
            return Image("drawing-panel-background").resizable()
        case .drawingPanelTutorialBackgroundImage:
            return Image("drawing-panel-tutorial-background").resizable()
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
        case .wordsButton:
            return Image("words-button").resizable()
        case .lettersButton:
            return Image("letters-button").resizable()
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
        case .achievementsButton:
            return Image("achievments-button").resizable()
        case .achievementItemBackground:
            return Image("achievement-background").resizable()
        case .progressBarBackground:
            return Image("progress-bar-background").resizable()
        case .progressBarIndicator:
            return Image("progress-bar").resizable()
        case .goldMedal:
            return Image("gold-medal").resizable()
        case .silverMedal:
            return Image("silver-medal").resizable()
        case .ribbon:
            return Image("ribbon").resizable()
        }
    }
}
