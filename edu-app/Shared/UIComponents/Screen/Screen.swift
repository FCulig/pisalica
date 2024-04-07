//
//  Grid.swift
//  edu-app
//
//  Created by Filip Culig on 30.01.2023..
//

import SwiftUI

// MARK: - Screen -

struct Screen: View {
    // MARK: - Private properties -

    private let shouldBlurBackground: Bool
    private let shouldShowBackButton: Bool

    private let centerContent: AnyView?
    private let topLeftContent: AnyView?
    private let topRightContent: AnyView?

    // MARK: - Public properties -

    @Environment(\.dismiss) var dismiss

    // MARK: - Initializer -

    public init(shouldBlurBackground: Bool = true,
                shouldShowBackButton: Bool = false,
                centerContent: AnyView? = nil,
                topLeftContent: AnyView? = nil,
                topRightContent: AnyView? = nil)
    {
        self.shouldBlurBackground = shouldBlurBackground
        self.shouldShowBackButton = shouldShowBackButton
        self.centerContent = centerContent
        self.topLeftContent = topLeftContent
        self.topRightContent = topRightContent
    }

    // MARK: - Body -

    var body: some View {
        foregroundContent
            .background(background)
            .navigationBarHidden(true)
    }

    // MARK: - Back button -

    private var backButton: some View {
        HStack {
            VStack(alignment: .leading) {
                Button(action: {
                           dismiss()
                       },
                       image: AppImage.previousButton.image)
                    .frame(height: 70, alignment: .top)
                    .padding(.top, 15)
                    .padding(.leading, isTablet ? 15 : 0)

                Spacer()
            }
            Spacer()
        }
    }
}

// MARK: - Foreground content -

private extension Screen {
    @ViewBuilder var foregroundContent: some View {
        if isTablet {
            tabletForegroundContent
        } else {
            phoneForegroundContent
        }
    }
    
    // MARK: - Tablet layout -

    var tabletForegroundContent: some View {
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    centerContent
                    Spacer()
                }
                Spacer()
            }

            VStack {
                HStack {
                    if shouldShowBackButton && topLeftContent == nil {
                        backButton
                    } else {
                        topLeftContent
                    }

                    Spacer()

                    topRightContent
                }

                Spacer()
            }
        }
    }
    
    // MARK: - Phone layout -
    
    var phoneForegroundContent: some View {
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    centerContent
                    Spacer()
                }
                Spacer()
            }

            VStack {
                HStack {
                    if topLeftContent == nil {
                        backButton
                    } else {
                        topLeftContent
                    }

                    Spacer()

                    topRightContent
                }

                Spacer()
            }
        }
    }
}

// struct Grid_Previews: PreviewProvider {
//    static var previews: some View {
//        Grid()
//    }
// }
