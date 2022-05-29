//
//  LevelButton.swift
//  edu-app
//
//  Created by Filip Culig on 16.04.2022..
//

import SwiftUI

struct LevelButton: View {
    private let isTablet = UIDevice.current.localizedModel == "iPad"

    let level: Level

    var body: some View {
        HStack {
            if level.isLocked {
                Image(level.lockedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(level.unlockedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(height: isTablet ? 130 : 75, alignment: .center)
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
