//
//  MainMenuViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import Combine
import CoreData
import Foundation

// MARK: - MainMenuViewModel -

extension MainMenuView {
    class ViewModel: ObservableObject {}
}

// MARK: - Public methods -

extension MainMenuView.ViewModel {
    func configureCoreData(with context: NSManagedObjectContext) {
        let preloadedDataKey = "didPreloadData"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) != true {
            guard let levelsUrlPath = Bundle.main.url(forResource: "Levels", withExtension: "json") else { return }

            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: levelsUrlPath)
                let jsonData = try decoder.decode([DecodableLevel].self, from: data)

                guard jsonData.count > 0 else { return }

                for level in jsonData {
                    let levelCoreData = Level(context: context)
                    levelCoreData.id = UUID()
                    levelCoreData.name = level.name
                    levelCoreData.numberOfLines = level.numberOfLines
                    levelCoreData.results = level.results
                    levelCoreData.lockedImage = level.lockedImage
                    levelCoreData.unlockedImage = level.unlockedImage
                    try! context.save()
                }

                userDefaults.set(true, forKey: preloadedDataKey)
            } catch { print(error) }
        }
    }
}
