//
//  MainMenuView.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

struct MainMenuView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var viewModel: ViewModel
    @State var isPlayActive = false

    var body: some View {
        NavigationView {
            ZStack {
                AppImage.houseBackgroundImage.image
                    .ignoresSafeArea()
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        List {
                            NavigationLink(destination: LevelSelectView(), isActive: $isPlayActive) {
                                Button {
                                    viewModel.configureCoreData(with: managedObjectContext)
                                    isPlayActive = true
                                } label: {
                                    AppImage.playButton.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
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

#if DEBUG
    import CoreData

    struct MainMenuView_Previews: PreviewProvider {
        static var previews: some View {
            let container = NSPersistentContainer(name: "Game")

            container.loadPersistentStores { _, error in
                guard let error = error else { return }
                fatalError("Core Data error: '\(error.localizedDescription)'.")
            }

            return MainMenuView(viewModel: .init())
                .previewInterfaceOrientation(.landscapeLeft)
                .environment(\.managedObjectContext, container.viewContext)
        }
    }
#endif
