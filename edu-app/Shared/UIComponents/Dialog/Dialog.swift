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
                Rectangle()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .foregroundColor(.black.opacity(0.85))
                    .onTapGesture { hide() }
                
                dialog
            }
        }
    }
    
    private var dialog: some View {
        ZStack {
            AppImage.dialogBackground.image
                .scaledToFit()
                .overlay(dialogContent)
                .padding(.vertical, isTablet ? 300 : 150)

            VStack {
                HStack {
                    Spacer()
                    Button(action: { hide() },
                           image: AppImage.closeButton.image)
                        .frame(width: 65)
                        .padding(.vertical, isTablet ? 300 : 150)
                        .padding(.horizontal, isTablet ? 150 : 0)
                }
                Spacer()
            }
        }
    }
    
    private var dialogContent: some View {
//        ZStack {
            Rectangle()
                .foregroundColor(AppColor.brownBackground.color)
                .border(AppColor.brownBorder.color, width: 5)
                .padding(65)
            
//            content
//        }
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
