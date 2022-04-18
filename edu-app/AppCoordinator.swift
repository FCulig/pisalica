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
    private var cancellabels: Set<AnyCancellable> = []

    // MARK: - Start -

    @MainActor func start() -> some View {
        configureCoreData()
        let mainMenuViewModel = MainMenuView.ViewModel()
        return MainMenuView(viewModel: mainMenuViewModel)
    }
}

private extension AppCoordinator {
    func configureCoreData() {
        let preloadedDataKey = "didPreloadData"
        let userDefaults = UserDefaults.standard

//        if userDefaults.bool(forKey: preloadedDataKey) == false {
        guard let levelsUrlPath = Bundle.main.url(forResource: "Levels", withExtension: "json") else { return }

        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: levelsUrlPath)
            let jsonData = try decoder.decode([DecodableLevel].self, from: data)
            print(jsonData)
//                userDefaults.setValue(true, forKey: preloadedDataKey)
        } catch { print(error) }
//        }
    }
}
