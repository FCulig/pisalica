//
//  MainMenuView.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

struct MainMenuView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            ZStack {
                AppImage.houseBackgroundImage.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        List {
                            ZStack {
                                AppImage.playButton.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                NavigationLink(destination: LevelSelectView()) {
                                    EmptyView()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .frame(width: 200, height: 200, alignment: .center)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(viewModel: .init())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
