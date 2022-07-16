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
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    achievementsPanel
                    Spacer()
                }
                Spacer()
            }
            backButton
        }
    }

    var backButton: some View {
        HStack {
            VStack(alignment: .leading) {
                SwiftUI.Button {
                    dismiss()
                } label: {
                    AppImage.previousButton.image
                        .aspectRatio(contentMode: .fit)
                }
                .frame(height: 70, alignment: .top)
                .padding(.top, 15)
                .padding(.leading, isTablet ? 15 : 0)

                Spacer()
            }
            Spacer()
        }
    }

    var achievementsPanel: some View {
        ZStack {
            AppImage.panelBackgroundImage.image

            ScrollView(showsIndicators: false) {
                ForEach(viewModel.achievements, id: \.self) { achievement in
                    AchievementItemView(achievement: achievement)
                }
            }
            .padding(.vertical, isTablet ? 70 : 40)
            .padding(.bottom, isTablet ? 10 : 0)
            .padding(.horizontal, isTablet ? 85 : 50)
            .padding(.leading, isTablet ? 5 : 0)
        }
        .padding(.top, isTablet ? 120 : 55)
        .padding(.bottom, isTablet ? 10 : 0)
        .padding(.leading, 130)
        .padding(.trailing, 90)
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
