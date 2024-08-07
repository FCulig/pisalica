//
//  SettingsViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 03.09.2022..
//

import Foundation

// MARK: - SettingsView.ViewModel -

extension SettingsListView {
    final class ViewModel: ObservableObject {
        // MARK: - Public properties -

        @Published var isMusicMuted: Bool
        @Published var isSoundEffectMuted: Bool
        @Published var isDebugMode: Bool

        // MARK: - Private properties -

        private var settingsService: SettingsServiceful

        // MARK: - Initializer -

        public init(settingsService: SettingsServiceful) {
            self.settingsService = settingsService

            isMusicMuted = settingsService.isMusicMuted
            isSoundEffectMuted = settingsService.isSoundEffectMuted
            isDebugMode = settingsService.isDebugMode
        }
    }
}

// MARK: - Public methods -

extension SettingsListView.ViewModel {
    func updateSoundSetting(isMuted: Bool) {
        isSoundEffectMuted = isMuted
        settingsService.isSoundEffectMuted = isMuted
    }

    func updateMusicSetting(isMuted: Bool) {
        isMusicMuted = isMuted
        settingsService.isMusicMuted = isMuted
        if isMuted { BackgroundMusicService.shared.stop() }
        else { BackgroundMusicService.shared.start() }
    }

    func updateDebugModeSetting(isDebugMode: Bool) {
        self.isDebugMode = isDebugMode
        settingsService.isDebugMode = isDebugMode
    }
}
