//
//  AppColor.swift
//  edu-app
//
//  Created by Filip Culig on 26.04.2022..
//

import SwiftUI

enum AppColor {
    case brown

    var color: Color {
        switch self {
        case .brown:
            return Color("brown")
        }
    }
}
