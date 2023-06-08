//
//  AppColor.swift
//  edu-app
//
//  Created by Filip Culig on 26.04.2022..
//

import SwiftUI

enum AppColor {
    case brownBorder
    case brownBackground

    var color: Color {
        switch self {
        case .brownBorder:
            return Color("brown-border")
        case .brownBackground:
            return Color("brown-background")
        }
    }
}
