//
//  AchievementsView.swift
//  edu-app
//
//  Created by Filip Culig on 07.05.2022..
//

import SwiftUI

// MARK: - AchievementsView -

struct AchievementsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel

    // MARK: - Initializer -

    public init(achievementService: AchievementServiceful) {
        let wrappedViewModel = ViewModel(achievementService: achievementService)
        _viewModel = StateObject(wrappedValue: wrappedViewModel)
    }

    // MARK: - View components -

    var body: some View {
        Screen(shouldShowBackButton: true,
               centerContent: AnyView(achievementsPanel))
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
            .padding(10)
        }
        .padding(.vertical, isTablet ? 100 : 0)
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
