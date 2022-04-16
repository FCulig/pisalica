//
//  MainMenuView.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var viewModel: MainMenuViewModel

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
                            Button(action: {
                                print("button pressed")
                            }) {
                                AppImage.playButton.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
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
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(viewModel: .init())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
