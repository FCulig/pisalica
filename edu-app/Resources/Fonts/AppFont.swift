//
//  AppFont.swift
//  edu-app
//
//  Created by Filip Culig on 05.03.2022..
//

import SwiftUI

enum AppFont {
    case title
    case achievementTitle

    var font: Font {
        switch self {
        case .title:
            return Font.custom("RobotoCondensed-Bold", size: 50)
        case .achievementTitle:
            return Font.custom("RobotoCondensed-Bold", size: 30).weight(.black)
        }
    }
}
