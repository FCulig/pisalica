//
//  View+isTablet.swift
//  edu-app
//
//  Created by Filip Čulig on 19.11.2023..
//

import SwiftUI

extension View {
    // TODO: Move this as enviroment object
    var isTablet: Bool {
        UIDevice.current.localizedModel == "iPad"
    }
}
