//
//  edu_appApp.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

@main
struct edu_appApp: App {
    var body: some Scene {
        return WindowGroup {
            ParentalGateDialogView {
                MainMenuRouterView()
            }
        }
    }
}
