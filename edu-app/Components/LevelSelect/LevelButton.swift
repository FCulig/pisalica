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
            if level.isLocked {
                //                level.level.lockedImage
                Text("Locked image")
            } else {
                level.level.unlockedImage
            }
        }
        .frame(width: 70, height: 70, alignment: .center)
    }

    public init(_ level: Level) {
        self.level = level
    }
}

struct LevelButton_Previews: PreviewProvider {
    static var previews: some View {
        LevelButton(Level(isLocked: false, level: Levels.A))
    }
}
