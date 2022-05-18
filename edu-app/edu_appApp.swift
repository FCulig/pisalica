//
//  edu_appApp.swift
//  edu-app
//
//  Created by Filip Culig on 15.02.2022..
//

import SwiftUI

@main
struct edu_appApp: App {
    @StateObject private var dataController = DataController()
    var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.start(context: dataController.container.viewContext)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
