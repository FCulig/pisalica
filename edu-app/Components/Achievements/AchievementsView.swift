//
//  AchievementsView.swift
//  edu-app
//
//  Created by Filip Culig on 07.05.2022..
//

import SwiftUI

// MARK: - AchievementsView -

struct AchievementsView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel

    // MARK: - Initializer -

    public init(achievementService: AchievementService) {
        let wrappedViewModel = ViewModel(achievementService: achievementService)
        _viewModel = StateObject(wrappedValue: wrappedViewModel)
    }

    // MARK: - View components -

    var body: some View {
        ZStack {
            AppImage.houseBackgroundImage.image
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 3)
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
            .padding(.bottom, 50)
            .padding(.horizontal, 40)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }

    var backButton: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    AppImage.previousButton.image
                        .aspectRatio(contentMode: .fit)
                }
                .frame(height: 70, alignment: .top)

                Spacer()
            }
            .padding(.vertical, 45)
            Spacer()
        }
    }

    var achievementsPanel: some View {
        ZStack {
            ZStack {
                AppImage.panelBackgroundImage.image

                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.achievements, id: \.self) { achievement in
                        AchievementItemView(achievement: achievement)
                    }
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 60)
            }
            .padding(.top, 35)
            .padding(.bottom, 15)
            .padding(.leading, 70)
            .padding(.trailing, 25)
        }
        .padding(.horizontal, 50)
        .onLoad { viewModel.getAchievements(context: moc) }
    }
}

// MARK: - Preview -

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(achievementService: .init())
    }
}
