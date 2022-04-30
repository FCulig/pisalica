//
//  LevelButton.swift
//  edu-app
//
//  Created by Filip Culig on 16.04.2022..
//

import SwiftUI

struct LevelButton: View {
    let level: Level

    var body: some View {
        HStack {
//            Image("A-unlocked")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
            if level.isLocked {
                Image(level.lockedImage ?? "A-locked")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(level.unlockedImage ?? "A-unlocked")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(height: 75, alignment: .center)
    }

    public init(_ level: Level) {
        self.level = level
    }
}

struct LevelButton_Previews: PreviewProvider {
    static var previews: some View {
        LevelButton(Level())
    }
}
