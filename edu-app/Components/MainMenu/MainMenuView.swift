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
        Text("Main menu")
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(model: .init())
    }
}
