//
//  Dialog.swift
//  edu-app
//
//  Created by Filip Culig on 26.09.2022..
//

import SwiftUI

// MARK: - Dialog -

struct Dialog<Content: View>: View {
    
    // MARK: - Public properties -
    
    @State var isShowing: Bool = true
    
    // MARK: - Private properties -
    
    private let content: Content
    
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
    
    var background: some View {
        Rectangle()
            .ignoresSafeArea()
            .scaledToFill()
            .foregroundColor(.black.opacity(0.85))
            .onTapGesture { hide() }
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
