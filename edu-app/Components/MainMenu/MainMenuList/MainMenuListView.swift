//
//  MainMenuListView.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import SwiftUI

struct MainMenuListView: View {
    var body: some View {
        List {
            MainMenuListItem(displayName: "Pisanje slova")
            MainMenuListItem(displayName: "Kviz pisanja")
        }.listStyle(.plain)
    }
}

struct MainMenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuListView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}
 
