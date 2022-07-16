//
//  DataController.swift
//  edu-app
//
//  Created by Filip Culig on 18.04.2022..
//

import CoreData
import Foundation

final class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Game")

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }

    func fetchData() {}
}
