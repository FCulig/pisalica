//
//  WritingWordsView.swift
//  edu-app
//
//  Created by Filip Culig on 04.06.2022..
//

import SwiftUI

// MARK: - WritingWordsView -

struct WritingWordsView: View {
    // MARK: - Private properties -

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ViewModel
    private let isTablet = UIDevice.current.localizedModel == "iPad"

    // MARK: - Initializer -

    public init(levelService: LevelServiceful) {
        let wrappedViewModel = ViewModel(levelService: levelService)
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
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .blur(radius: 3)
                )
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.bottom)
        }
    }

    var foregroundContent: some View {
        ZStack {
            drawingCanvasContainer
            buttons
        }
        .onLoad { viewModel.drawingCanvasViewModel.configureLineColor() }
    }

    var drawingCanvasContainer: some View {
        ZStack {
            AppImage.drawingPanelBackgroundImage.image
            Image(viewModel.drawingCanvasViewModel.level.wordImage ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: isTablet ? 200 : 100)
                .padding(.bottom, isTablet ? 270 : 100)
            drawingCanvas
        }
        .padding(.top, 70)
        .padding(.bottom, 10)
        .padding(.horizontal, 130)
    }

    var drawingCanvas: some View {
        ZStack {
            letterPlaceholders
                .padding(.top, isTablet ? 450 : 200)
            DrawingCanvasView(viewModel: viewModel.drawingCanvasViewModel)
                .padding(.leading, isTablet ? 69 : 44)
                .padding(.trailing, isTablet ? 65 : 40)
                .padding(.top, isTablet ? 59 : 27)
                .padding(.bottom, isTablet ? 75 : 34)
        }
    }

    var letterPlaceholders: some View {
        HStack {
            ForEach(0 ..< (viewModel.drawingCanvasViewModel.level.name?.count ?? 0), id: \.self) { _ in
                Rectangle()
                    .frame(width: 85, height: 10)
                    .foregroundColor(.black)
                    .padding(.trailing, 10)
            }
        }
    }

    var buttons: some View {
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
            Spacer()
            VStack(alignment: .trailing) {
                Button {
//                    showVideoTutorialDialog = true
                } label: {
                    AppImage.hintButton.image
                        .scaledToFit()
                        .frame(height: 70, alignment: .top)
                }
                Spacer()

//                if isTablet {
//                    VStack {
//                        AppImage.zoomInButton.image
//                            .scaledToFit()
//                            .frame(height: 70, alignment: .top)
//                            .onTapGesture {
//                                viewModel.setCanvasImagePadding(50)
//                            }
//                        AppImage.zoomOutButton.image
//                            .scaledToFit()
//                            .frame(height: 70, alignment: .top)
//                            .onTapGesture {
//                                viewModel.setCanvasImagePadding(220)
//                            }
//                    }
//                }

                Spacer()
                Button {
                    viewModel.drawingCanvasViewModel.clearInk()
                } label: {
                    AppImage.trashCanButton.image
                        .scaledToFit()
                        .frame(height: 70, alignment: .top)
                }
            }
        }
        .padding(.vertical, isTablet ? 30 : 15)
        .padding(.leading, isTablet ? 15 : 0)
        .padding(.trailing, isTablet ? 15 : 0)
    }
}

// MARK: - Previews -

struct WritingWordsView_Previews: PreviewProvider {
    static var previews: some View {
        WritingWordsView(levelService: LevelServicePreviewMock())
    }
}