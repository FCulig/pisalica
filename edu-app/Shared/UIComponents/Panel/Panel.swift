//
//  Panel.swift
//  edu-app
//
//  Created by Filip Culig on 31.10.2022..
//

import SwiftUI

// MARK: - Panel -

struct Panel<Content: View>: View {
    private let shouldShowCloseButton: Bool
    private let onCloseAction: (()->Void)
    @ViewBuilder private var content: Content
    
    // MARK: - Initializer -
    
    init(shouldShowCloseButton: Bool = false,
         onCloseAction: @escaping (()->Void) = {},
         @ViewBuilder content: () -> Content) {
        self.shouldShowCloseButton = shouldShowCloseButton
        self.onCloseAction = onCloseAction
        self.content = content()
    }

    // MARK: - Body -

    var body: some View {
        AppImage.dialogBackground.image
            .scaledToFit()
            .overlay(panelContent)
    }

    // MARK: - View components -
    
    private var panelContent: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                if shouldShowCloseButton {
                    Button(action: { onCloseAction() },
                           image: AppImage.closeButton.image)
                    .frame(width: 65)
                }
            }
            
            Rectangle()
                .foregroundColor(AppColor.brownBackground.color)
                .overlay{
                    content
                }
                .border(AppColor.brownBorder.color, width: 5)
                .padding(.horizontal, isTablet ? 80 : 40)
                .padding(.bottom, isTablet ? 80 : 45)
                .padding(.top, shouldShowCloseButton ? 0 : (isTablet ? 65 : 45))
        }
    }
}

// MARK: - Previews -

//struct Panel_Previews: PreviewProvider {
//    static var previews: some View {
//        Panel {
//            Text("Test")
//        }
//        .previewInterfaceOrientation(.landscapeLeft)
//        .previewDevice("iPhone 13 Pro Max")

//        Panel()
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDevice("iPad Air (5th generation)")
//    }
//}
