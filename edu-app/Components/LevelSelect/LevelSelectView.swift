//
//  LevelSelectView.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import SwiftUI

// MARK: - LevelSelectView -

struct LevelSelectView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ViewModel = .init()
//    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Level>

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
        .navigationBarHidden(true)
    }

    var levelSelectPanel: some View {
        ZStack {
            AppImage.panelBackgroundImage.image
            ZStack {
                Rectangle()
                    .background(.white)
                    .cornerRadius(5)
                    .opacity(0.45)
                    .blur(radius: 3)
                    .padding(.horizontal, 90)
                    .padding(.vertical, 65)
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 35) {
//                    ForEach(viewModel.displayedLevels, id: \.self) { level in
//                        // TODO: Only if is enabled
//                        NavigationLink {
//                            WritingLevelView(drawingCanvasViewModel: .init(level: level.level))
//                        } label: {
//                            LevelButton(level)
//                        }
//                    }
                    Text("TMP")
                }
                .padding(.horizontal, 95)
                .padding(.vertical, 70)
            }
            pageControlButtons
        }
        .padding(.horizontal, 70)
        .padding(.vertical, 10)
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
        LevelSelectView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
