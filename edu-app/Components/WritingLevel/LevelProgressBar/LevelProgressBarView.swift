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
        isTablet ? 23 : 13
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
                    .padding(.vertical, isTablet ? 33 : 21)
                    .padding(.leading, leadingPadding)
                    .padding(.bottom, isTablet ? 2 : 0.5)
                    .padding(.trailing, viewModel.trailingPadding < (isTablet ? 850 : 480) ?
                        viewModel.trailingPadding : (isTablet ? 840 : 470))
            }
        }
    }

    var levelCheckpoints: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            createProgressBarCheckpoint(onTap: viewModel.showGuidesLevel,
                                        buttonImage: Image(viewModel.level.guideImage ?? ""),
                                        isLocked: false)
            Spacer()
                .frame(width: isTablet ? 80 : 120)

            createProgressBarCheckpoint(onTap: viewModel.showOutlineLevel,
                                        buttonImage: Image(viewModel.level.outlineImage ?? ""),
                                        isLocked: !viewModel.isShowOutlineLevelButtonEnabled)
            Spacer()
                .frame(width: isTablet ? 160 : 110)

            createProgressBarCheckpoint(onTap: viewModel.showBlankLevel,
                                        isLocked: !viewModel.isShowBlankLevelButtonEnabled)

            Spacer()
                .frame(width: isTablet ? 230 : 165)
        }
    }
}

// MARK: - View related methods -

private extension LevelProgressBarView {
    func createProgressBarCheckpoint(onTap: @escaping () -> Void,
                                     buttonImage: Image? = nil,
                                     isLocked: Bool) -> some View
    {
        return ZStack {
            if isLocked {
                RoundedButton(buttonImage: buttonImage, isLocked: true)
                    .frame(width: isTablet ? 55 : 55)
            } else {
                Button {
                    onTap()
                } label: {
                    RoundedButton(buttonImage: buttonImage, isLocked: false)
                        .frame(width: isTablet ? 55 : 55)
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
                                              progress: .init(10),
                                              level: .init(),
                                              isTablet: false))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 13 Pro Max")

        LevelProgressBarView(viewModel: .init(progressGoal: 10,
                                              showGuidesLevel: {},
                                              showOutlineLevel: {},
                                              showBlankLevel: {},
                                              isShowOutlineLevelButtonEnabled: .init(false),
                                              isShowBlankLevelButtonEnabled: .init(false),
                                              progress: .init(10),
                                              level: .init(),
                                              isTablet: true))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Air (5th generation)")
    }
}
