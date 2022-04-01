//
//  MainMenuListItem.swift
//  edu-app
//
//  Created by Filip Culig on 16.02.2022..
//

import SwiftUI

struct MainMenuListItem: View {
    let displayName: String

    var body: some View {
        Button(action: {
            print("button pressed")
        }) {
            ZStack {
                AppImage.textButtonBackground.image
                    .resizable()
                    .renderingMode(.original)
                    .frame(height: 90, alignment: .center)
                Text(displayName)
                    .foregroundColor(.white)
                    .font(AppFont.bubblegum.font)
                    .fontWeight(.bold)
            }
        }.listRowSeparator(.hidden)
    }
}

struct MainMenuListItem_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuListItem(displayName: "Igraj")
    }
}
