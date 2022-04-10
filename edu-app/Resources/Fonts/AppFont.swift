//
//  AppFont.swift
//  edu-app
//
//  Created by Filip Culig on 05.03.2022..
//

import Foundation
import SwiftUI

enum AppFont {
    case title

    var font: Font {
        switch self {
        case .title:
            return Font.custom("RobotoCondensed-Bold", size: 50)
        }
    }
}
