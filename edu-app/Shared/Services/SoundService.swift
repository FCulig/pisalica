//
//  SoundService.swift
//  edu-app
//
//  Created by Filip Culig on 15.07.2022..
//

import AVFoundation

// MARK: - SoundServiceful -

protocol SoundServiceful {
    func playButtonTap()
}

// MARK: - SoundService -

final class SoundService: NSObject, AVAudioPlayerDelegate, SoundServiceful {
    var audioPlayer = AVAudioPlayer()

    // MARK: - Initializer -
}

// MARK: - Public methods -

extension SoundService {
    func playButtonTap() {
        play(sound: "button-tap")
    }
}

// MARK: - Private methods -

private extension SoundService {
    func play(sound: String, type: String = "mp3") {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer.play()
            } catch {
                print("ERROR while playing button tap sound")
            }
        }
    }
}
