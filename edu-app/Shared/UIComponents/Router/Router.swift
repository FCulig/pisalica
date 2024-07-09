//
//  AppRouter.swift
//  edu-app
//
//  Created by Filip Čulig on 03.07.2024..
//

import SwiftUI
import Combine

// MARK: - Router -
class Router: ObservableObject {
    // MARK: - Public properties -
    
    @Published var path: NavigationPath = NavigationPath()
    
    // MARK: - Private properties -
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Navigation controls -
    
    func navigateTo(_ appRoute: MainMenuRoute) {
        path.append(appRoute)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func subscribeToNavigationEvents(from publisher: AnyPublisher<MainMenuRoute, Never>) {
        publisher
            .sink { [weak self] in self?.navigateTo($0) }
            .store(in: &cancellables)
    }
}
