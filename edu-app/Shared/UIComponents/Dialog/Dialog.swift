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
    
    private let onDismissDialog: (()->Void)
    private let content: Content
    
    // MARK: - Initializer -
    
    public init(onDismissDialog: @escaping (()->Void), @ViewBuilder content: () -> Content) {
        self.onDismissDialog = onDismissDialog
        self.content = content()
    }
    
    // MARK: - Body -
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.black.opacity(0.85))
                .onTapGesture { onDismissDialog() }
            
            Panel(shouldShowCloseButton: true,
                  onCloseAction: { onDismissDialog() }) {
                content
            }
                  .padding(.vertical, isTablet ? 100 : 0)
        }
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
