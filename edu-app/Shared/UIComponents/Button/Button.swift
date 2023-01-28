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
    // MARK: - Private properties -

    private let action: Action?

    // MARK: - Public properties -

    @State var image: Image
    @State var isDisabled: Bool

    // MARK: - Initializer -

    init(action: Action? = nil,
         image: Image,
         isDisabled: Bool = false)
    {
        self.action = action
        self.image = image
        self.isDisabled = isDisabled
    }

    // MARK: - Body -

    var body: some View {
        SwiftUI.Button {
            action?()
            SoundService.shared.playButtonTap()
        } label: {
            image.scaledToFit()
        }
        .disabled(isDisabled)
    }
}

// MARK: - Previews -

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
//        Button()
    }
}
