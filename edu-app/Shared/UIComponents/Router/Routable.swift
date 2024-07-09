//
//  Routable.swift
//  edu-app
//
//  Created by Filip Čulig on 09.07.2024..
//

import Combine

protocol Route { }

protocol Routable {
    var event: AnyPublisher<any Route, Never> { get }
}
