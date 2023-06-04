//
//  Dialog.swift
//  edu-app
//
//  Created by Filip Culig on 26.09.2022..
//

import SwiftUI

// MARK: - Dialog -

struct Dialog<Content: View>: View {
    // MARK: - Private properties -
    
    private let isTablet = UIDevice.current.localizedModel == "iPad"
    private let content: Content
    
    // MARK: - Public properties -
    
    @State var isShowing: Bool = true
    
    // MARK: - Initializer -
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    // MARK: - Body -
    
    var body: some View {
        ZStack {
            if isShowing {
                background
                
                content
            }
        }
    }
    
    private var background: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .scaledToFill()
                .foregroundColor(.black.opacity(0.85))
                .onTapGesture { hide() }
            
            dialogBackground
        }
    }
    
    private var dialogBackground: some View {
        ZStack {
            AppImage.panelBackgroundImage.image
                .scaledToFit()
                .padding(.vertical, isTablet ? 300 : 150)

            VStack {
                HStack {
                    Spacer()
                    Button(action: { hide() },
                           image: AppImage.closeButton.image)
                        .frame(width: 65)
                        .padding(.vertical, isTablet ? 300 : 150)
                        .padding(.horizontal, isTablet ? 100 : 0)
                }
                Spacer()
            }
        }
    }
}

// MARK: - Public functions -

extension Dialog {
    func show() {
        isShowing = true
    }
    
    func hide() {
        isShowing = false
    }
}

// MARK: - Previews -

//struct Dialog_Previews: PreviewProvider {
//    static var previews: some View {
//        Dialog()
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDevice("iPhone 13 Pro Max")
//
//        Dialog()
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDevice("iPad Air (5th generation)")
//    }
//}
