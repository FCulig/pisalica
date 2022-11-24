//
//  Dialog.swift
//  edu-app
//
//  Created by Filip Culig on 26.09.2022..
//

import SwiftUI

// MARK: - Dialog -

struct Dialog: View {
    // MARK: - Body -

    var body: some View {
        Text("as")
    }
}

// MARK: - Previews -

struct Dialog_Previews: PreviewProvider {
    static var previews: some View {
        Dialog()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        Dialog()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
