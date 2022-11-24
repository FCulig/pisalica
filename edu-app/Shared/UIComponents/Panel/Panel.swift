//
//  Panel.swift
//  edu-app
//
//  Created by Filip Culig on 31.10.2022..
//

import SwiftUI

// MARK: - Panel -

struct Panel<Content: View>: View {
    @ViewBuilder var content: Content

    // MARK: - Body -

    var body: some View {
        ZStack {
            AppImage.dialogBackground.image

            contentBackground
            
            content
        }
    }

    // MARK: - View components -

    var contentBackground: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue)

            Rectangle()
                .foregroundColor(.cyan)
                .padding(3)
        }
    }
}

// MARK: - Previews -

struct Panel_Previews: PreviewProvider {
    static var previews: some View {
        Panel {
            Text("Test")
        }
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDevice("iPhone 13 Pro Max")

//        Panel()
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDevice("iPad Air (5th generation)")
    }
}
