//
//  AchievementItemView.swift
//  edu-app
//
//  Created by Filip Culig on 07.05.2022..
//

import SwiftUI

// MARK: - AchievementItemView -

struct AchievementItemView: View {
    private let isTablet = UIDevice.current.localizedModel == "iPad"

    @State var achievement: Achievement

    // MARK: - View components -

    var body: some View {
        AppImage.achievementItemBackground.image
            .scaledToFit()
            .overlay {
                achievementContent
            }
    }

    var achievementContent: some View {
        HStack {
            Image(achievement.medalImage ?? "")
                .resizable()
                .scaledToFit()
                .padding(.top, 15)
            Spacer()
                .frame(width: 5)
            Text(achievement.name ?? "")
                .foregroundColor(.white)
                .shadow(color: .black, radius: 0, x: 3, y: 2)
                .font(.system(size: isTablet ? 35 : 20).weight(.bold))
            Spacer()
            ProgressBar(currentValue: Float(achievement.currentValue), maxValue: Float(achievement.target))
                .padding(.top, 20)
                .padding(.bottom, 10)
                .padding(.trailing, 20)
                .frame(width: isTablet ? 130 : 100)
        }
    }
}

// MARK: - Previews -

struct AchievementItemView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementItemView(achievement: Achievement())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        AchievementItemView(achievement: Achievement())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
