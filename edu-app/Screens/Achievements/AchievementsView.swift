//
//  AchievementsView.swift
//  edu-app
//
//  Created by Filip Culig on 07.05.2022..
//

import SwiftUI

// MARK: - AchievementsView -

struct AchievementsView: View {
    private let isTablet = UIDevice.current.localizedModel == "iPad"

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel

    // MARK: - Initializer -

    public init(achievementService: AchievementServiceful) {
        let wrappedViewModel = ViewModel(achievementService: achievementService)
        _viewModel = StateObject(wrappedValue: wrappedViewModel)
    }

    // MARK: - View components -

    var body: some View {
        if isTablet {
            foregroundContent
                .background(
                    AppImage.houseBackgroundTabletImage.image
                        .scaledToFill()
                        .ignoresSafeArea()
                        .offset(x: 80, y: 0)
                        .blur(radius: 3)
                )
                .navigationBarHidden(true)
        } else {
            foregroundContent
                .background(
                    AppImage.houseBackgroundImage.image
                        .scaledToFill()
                        .ignoresSafeArea()
                        .blur(radius: 3)
                )
                .navigationBarHidden(true)
        }
    }

    var foregroundContent: some View {
        VStack {
            HStack {
                backButton
                Spacer()
            }
            
            Spacer()
            
            achievementsPanel
            
            Spacer()
        }
    }

    var backButton: some View {
        Button(action: {
                   dismiss()
               },
               image: AppImage.previousButton.image)
            .frame(height: 70, alignment: .top)
            .padding(.top, 15)
            .padding(.leading, isTablet ? 15 : 0)
    }

    var achievementsPanel: some View {
        Panel {
            ScrollView {
                // For some reason ScrollView is acting like a ZStack
                // and stacking elements on top of each other. So to prevent that,
                // wrap it in VStack.
                VStack {
                    ForEach(viewModel.achievements, id: \.self) { achievement in
                        AchievementItemView(achievement: achievement)
                    }
                }
            }
        }
        .onAppear { viewModel.getAchievements() }
    }
}

// MARK: - Preview -

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(achievementService: AchievementServicePreviewMock())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        AchievementsView(achievementService: AchievementServicePreviewMock())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
