//
//  Button.swift
//  edu-app
//
//  Created by Filip Culig on 16.07.2022..
//

import SwiftUI

// MARK: - Button -

/// Custom UI component. Specific to the Pisanka app requirements.
struct Button: View {
    private let action: Action
    private let image: Image

    // MARK: - Initializer -

    init(action: @escaping Action, image: Image) {
        self.action = action
        self.image = image
    }

    // MARK: - Body -

    var body: some View {
        SwiftUI.Button {
            action()
        } label: {
            image.scaledToFit()
        }
    }
}

// MARK: - Previews -

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
//        Button()
    }
}
