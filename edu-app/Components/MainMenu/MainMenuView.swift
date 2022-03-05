//
//  MainMenuView.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

struct MainMenuView: View {
    
    @ObservedObject var model: MainMenuViewModel
    
    var body: some View {
        NavigationView {
            MainMenuListView()
                .frame(width: 500, height: 600, alignment: .center)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(model: .init())
.previewInterfaceOrientation(.landscapeLeft)
    }
}
