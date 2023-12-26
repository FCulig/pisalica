//
//  Publisher+AssignWeak.swift
//  edu-app
//
//  Created by Filip Čulig on 25.12.2023..
//

import Combine

public extension Publisher where Self.Failure == Never {
    func assignWeak<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
    
    func assignWeak<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output?>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
