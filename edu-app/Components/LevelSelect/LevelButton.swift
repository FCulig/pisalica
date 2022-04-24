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
            Image("A-unlocked")
                .resizable()
//            if level.isLocked {
//                Image(level.lockedImage ?? "A-locked")
//                    .resizable()
//            } else {
//                Image(level.unlockedImage ?? "A-unlocked")
//                    .resizable()
//            }
        }
        .frame(width: 110, height: 70, alignment: .center)
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
