//
//  BackgroundMusicService.swift
//  edu-app
//
//  Created by Filip Culig on 17.07.2022..
//

import AVFoundation

// MARK: - BackgroundMusicServiceful -

protocol BackgroundMusicServiceful {
    func start()
    func pause()
    func stop()
}

// MARK: - SoundService -

final class BackgroundMusicService: NSObject, AVAudioPlayerDelegate, BackgroundMusicServiceful {
    static let shared = BackgroundMusicService()

    var audioPlayer = AVAudioPlayer()
    private let settingsService: SettingsService = .init()
}

// MARK: - Public methods -

extension BackgroundMusicService {
    func start() {
        guard !audioPlayer.isPlaying else { return }
//        play(sound: "track-1")
    }

    func pause() {
        audioPlayer.pause()
    }

    func stop() {
        audioPlayer.stop()
    }
}

// MARK: - Private methods -

private extension BackgroundMusicService {
    func play(sound: String, type: String = "mp3") {
        if let path = Bundle.main.path(forResource: sound, ofType: type), !settingsService.isMusicMuted {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
//                audioPlayer.play()
            } catch {
                print("ERROR while playing background music")
            }
        }
    }
}
