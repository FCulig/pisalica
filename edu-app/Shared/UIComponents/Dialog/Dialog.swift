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
    private let onDismissDialog: (()->Void)
    private let content: Content
    
    // MARK: - Public properties -
    
//    @State var isShowing: Bool = false
    
    // MARK: - Initializer -
    
    public init(onDismissDialog: @escaping (()->Void), @ViewBuilder content: () -> Content) {
        self.onDismissDialog = onDismissDialog
        self.content = content()
    }
    
    // MARK: - Body -
    
    var body: some View {
        ZStack {
//            if isShowing {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(.black.opacity(0.85))
                    .onTapGesture { onDismissDialog() }
                
                AppImage.dialogBackground.image
                    .scaledToFit()
                    .overlay(dialogContent)
                    .padding(.vertical, isTablet ? 100 : 0)
//            }
        }
    }
    
    private var dialogContent: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                Button(action: { onDismissDialog() },
                       image: AppImage.closeButton.image)
                    .frame(width: 65)
            }
            
            Rectangle()
                .foregroundColor(AppColor.brownBackground.color)
                .border(AppColor.brownBorder.color, width: 5)
                .overlay{
                    content
                        .padding(.horizontal, isTablet ? 20 : 5)
                }
                .padding([.horizontal, .bottom], isTablet ? 65 : 30)
        }
    }
}

// MARK: - Public functions -

extension Dialog {
//    func show() {
//        isShowing = true
//    }
//    
//    func hide() {
//        isShowing = false
//    }
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
