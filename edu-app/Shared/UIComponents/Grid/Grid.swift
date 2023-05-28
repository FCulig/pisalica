//
//  Grid.swift
//  edu-app
//
//  Created by Filip Culig on 30.01.2023..
//

import SwiftUI

// MARK: - Grid -

struct Grid: View {
    // MARK: - Private properties -

    private let isTablet = UIDevice.current.localizedModel == "iPad"
    private let shouldBlurBackground: Bool
    private let onAppear: Action?

    private let centerContent: AnyView?
    private let topLeftContent: AnyView?
    private let topRightContent: AnyView?

    // MARK: - Public properties -

    @Environment(\.dismiss) var dismiss

    // MARK: - Initializer -

    public init(shouldBlurBackground: Bool = true,
                centerContent: AnyView? = nil,
                topLeftContent: AnyView? = nil,
                topRightContent: AnyView? = nil,
                onAppear: Action? = nil)
    {
        self.shouldBlurBackground = shouldBlurBackground
        self.centerContent = centerContent
        self.topLeftContent = topLeftContent
        self.topRightContent = topRightContent
        self.onAppear = onAppear
    }

    // MARK: - Body -

    var body: some View {
        if isTablet {
            foregroundContent
                .background(
                    AppImage.houseBackgroundTabletImage.image
                        .scaledToFill()
                        .ignoresSafeArea()
                        .offset(x: 80, y: 0)
                        .blur(radius: shouldBlurBackground ? 3 : 0)
                )
                .onAppear {
                    onAppear?()
                }
                .navigationBarHidden(true)
        } else {
            foregroundContent
                .background(
                    AppImage.houseBackgroundImage.image
                        .scaledToFill()
                        .ignoresSafeArea()
                        .blur(radius: shouldBlurBackground ? 3 : 0)
                )
                .onAppear {
                    onAppear?()
                }
                .navigationBarHidden(true)
        }
    }

    var foregroundContent: some View {
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

    // MARK: - Back button -

    var backButton: some View {
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

// struct Grid_Previews: PreviewProvider {
//    static var previews: some View {
//        Grid()
//    }
// }
