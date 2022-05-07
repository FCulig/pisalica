//
//  NavigationLazyView.swift
//  edu-app
//
//  Created by Filip Culig on 07.05.2022..
//

import SwiftUI

// MARK: - NavigationLazyView -

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
