//
//  AppCoordinator.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import Foundation
import SwiftUI

class AppCoordinator {
    
    // MARK: - Start -
    
    @MainActor func start() -> some View {
//        let mainMenuViewModel = MainMenuViewModel()
//        return MainMenuView(model: mainMenuViewModel)
        return WritingLevelView()
    }
}
