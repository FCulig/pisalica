//
//  LevelSelectView.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import SwiftUI

// MARK: - LevelSelectView -

struct LevelSelectView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ViewModel
    @FetchRequest(sortDescriptors: []) var levels: FetchedResults<Level>

    // MARK: - Initializer -

    public init(achievementService: AchievementService, coinsService: CoinsService) {
        let wrappedViewModel = ViewModel(achievementService: achievementService, coinsService: coinsService)
        _viewModel = StateObject(wrappedValue: wrappedViewModel)
    }

    // MARK: - View components -

    var body: some View {
        ZStack {
            AppImage.houseBackgroundImage.image
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 3)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    levelSelectPanel
                    Spacer()
                }
                Spacer()
            }
            backButton
        }
        .padding(.bottom, 50)
        .padding(.horizontal, 40)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }

    var levelSelectPanel: some View {
        ZStack {
            ZStack {
                AppImage.panelBackgroundImage.image

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 15) {
                    ForEach(viewModel.displayedLevels, id: \.self) { level in
                        if level.isLocked {
                            LevelButton(level)
                        } else {
                            NavigationLink {
                                NavigationLazyView(WritingLevelView(level: level,
                                                                    levelService: viewModel.levelService,
                                                                    achievementService: viewModel.achievementService,
                                                                    coinsService: viewModel.coinsService))
                            } label: {
                                LevelButton(level)
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
            .padding(.vertical, 45)
            .padding(.leading, 90)
            .padding(.trailing, 35)

            pageControlButtons
                .padding(.vertical, 10)
        }
        .padding(.horizontal, 50)
        .onLoad { viewModel.getPaginatedLevels(context: moc) }
    }

    var pageControlButtons: some View {
        VStack {
            Spacer()
            HStack {
                if viewModel.showPreviousPageButton {
                    Button {
                        viewModel.previousPage()
                    } label: {
                        AppImage.previousButton.image
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.leading, 50)
                }
                Spacer()
                if viewModel.showNextPageButton {
                    Button {
                        viewModel.nextPage()
                    } label: {
                        AppImage.nextButton.image
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
            .frame(height: 70, alignment: .center)
        }
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
}

struct LevelSelectView_Previews: PreviewProvider {
    static var previews: some View {
        return LevelSelectView(achievementService: .init(), coinsService: .init(context: .init(.privateQueue)))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
