//
//  LevelSelectView.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import SwiftUI

// MARK: - LevelSelectView -

struct LevelSelectView: View {
    @StateObject var viewModel: ViewModel = .init()

    var body: some View {
        ZStack {
            AppImage.houseBackgroundImage.image
                .resizable()
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
        }
        .navigationBarHidden(true)
    }

    var levelSelectPanel: some View {
        ZStack {
            AppImage.panelBackgroundImage.image
                .resizable()
            ZStack {
                Rectangle()
                    .background(.brown)
                    .cornerRadius(5)
                    .opacity(0.45)
                    .blur(radius: 3)
                    .padding(.horizontal, 90)
                    .padding(.vertical, 65)
                HStack {
                    ForEach(viewModel.levels, id: \.self) { level in
                        NavigationLink(destination: DrawingCanvasView(viewModel: .init(level: Levels.A))) {
                            LevelButton(level)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 70)
        .padding(.vertical, 10)
    }
}

struct LevelSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
