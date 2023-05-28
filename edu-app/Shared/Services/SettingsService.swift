//
//  SettingsService.swift
//  edu-app
//
//  Created by Filip Culig on 03.09.2022..
//

import Foundation

// MARK: - SettingsServiceful -

protocol SettingsServiceful {
    var isMusicMuted: Bool { get set }
    var isSoundEffectMuted: Bool { get set }
    var isDebugMode: Bool { get set }
}

// MARK: - SettingsService -

final class SettingsService: SettingsServiceful {
    // MARK: - Public properties -

    var isMusicMuted: Bool {
        get { UserDefaults.standard.bool(forKey: "isMusicMuted") }
        set { UserDefaults.standard.set(newValue, forKey: "isMusicMuted") }
    }

    var isSoundEffectMuted: Bool {
        get { UserDefaults.standard.bool(forKey: "isSoundEffectMuted") }
        set { UserDefaults.standard.set(newValue, forKey: "isSoundEffectMuted") }
    }

    var isDebugMode: Bool {
        get { UserDefaults.standard.bool(forKey: "isDebugMode") }
        set { UserDefaults.standard.set(newValue, forKey: "isDebugMode") }
    }

    // MARK: - Initializer

    public init() {}
}
