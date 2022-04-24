//
//  AppCoordinator.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import Combine
import SwiftUI

// MARK: - AppCoordinator -

class AppCoordinator {
    // MARK: - Start -

    @MainActor func start() -> some View {
        let mainMenuViewModel = MainMenuView.ViewModel()
        return MainMenuView(viewModel: mainMenuViewModel)
    }
}
