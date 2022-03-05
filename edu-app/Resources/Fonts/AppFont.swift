//
//  AppFont.swift
//  edu-app
//
//  Created by Filip Culig on 05.03.2022..
//

import Foundation
import SwiftUI

enum AppFont {
    case bubblegum
    
    var font: Font {
        switch self {
        case .bubblegum:
            return Font.custom("Bubblegum", size: 26)
        }
    }
}
