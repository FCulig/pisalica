//
//  LevelProgressBar.swift
//  edu-app
//
//  Created by Filip Culig on 30.05.2022..
//

import Combine
import SwiftUI

// MARK: - LevelProgressBar -

struct LevelProgressBarView: View {
    // MARK: - Constants -

    var leadingPadding: CGFloat {
        isTablet ? 29 : 13
    }

    var minTrailingPadding: CGFloat {
        isTablet ? 29 : 13
    }

    var maxTrailingPadding: CGFloat {
        isTablet ? 0 : 0
    }

    // MARK: - Private properties -

    private let isTablet = UIDevice.current.localizedModel == "iPad"
    @StateObject private var viewModel: ViewModel
    @State private var didReadSize = false

    // MARK: - Initializer -

    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View components -

    var body: some View {
        ZStack {
            AppImage.levelProgressBar.image
                .overlay(progressIndicator)
                .scaledToFit()

            levelCheckpoints
        }
    }

    var progressIndicator: some View {
        ZStack {
            if viewModel.currentProgress > 0 {
                Rectangle()
                    .cornerRadius(50)
                    .foregroundColor(.init(red: 0.20, green: 0.7, blue: 0.10))
                    .padding(.vertical, isTablet ? 98 : 21)
                    .padding(.leading, leadingPadding)
                    .padding(.bottom, isTablet ? 0 : 0.5)
                    .padding(.trailing, viewModel.trailingPadding < 480 ? viewModel.trailingPadding : 470)
            }
        }
    }

    var levelCheckpoints: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            createProgressBarCheckpoint(onTap: viewModel.showGuidesLevel,
                                        isEnabled: true,
                                        hideLine: true)
            Spacer()
                .frame(width: 100)
            createProgressBarCheckpoint(onTap: viewModel.showOutlineLevel, isEnabled: viewModel.isShowOutlineLevelButtonEnabled)
            Spacer()
                .frame(width: 110)
            createProgressBarCheckpoint(onTap: viewModel.showBlankLevel, isEnabled: viewModel.isShowBlankLevelButtonEnabled)
            Spacer()
                .frame(width: 165)
        }
    }
}

// MARK: - View related methods -

private extension LevelProgressBarView {
    func createProgressBarCheckpoint(onTap: @escaping () -> Void, isEnabled: Bool, hideLine: Bool = false) -> some View {
        return ZStack {
            HStack(spacing: 0) {
                Spacer()
                if !hideLine {
                    Rectangle()
                        .frame(width: 2, height: 38)
                        .foregroundColor(.black)
                    Spacer()
                }
            }

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 50)

                if isEnabled {
                    Button {
                        onTap()
                    } label: {
                        AppImage.nextButton.image
                            .scaledToFit()
                            .frame(width: 35)
                    }
                } else {
                    AppImage.achievementsButton.image
                        .scaledToFit()
                        .frame(width: 35)
                }
            }
        }
    }
}

struct LevelProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        LevelProgressBarView(viewModel: .init(progressGoal: 10,
                                              showGuidesLevel: {},
                                              showOutlineLevel: {},
                                              showBlankLevel: {},
                                              isShowOutlineLevelButtonEnabled: .init(false),
                                              isShowBlankLevelButtonEnabled: .init(false),
                                              progress: .init(10)))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        LevelProgressBarView(viewModel: .init(progressGoal: 10,
                                              showGuidesLevel: {},
                                              showOutlineLevel: {},
                                              showBlankLevel: {},
                                              isShowOutlineLevelButtonEnabled: .init(false),
                                              isShowBlankLevelButtonEnabled: .init(false),
                                              progress: .init(10)))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
