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
    case green

    var color: Color {
        switch self {
        case .brownBorder:
            Color("brown-border")
        case .brownBackground:
            Color("brown-background")
        case .green:
            Color("green")
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .brownBorder:
            UIColor(named: "brown-border")!
        case .brownBackground:
            UIColor(named: "brown-background")!
        case .green:
            UIColor(named: "green")!
        }
    }
}
