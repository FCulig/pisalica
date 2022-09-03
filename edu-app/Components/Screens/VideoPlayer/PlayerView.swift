//
//  PlayerView.swift
//  edu-app
//
//  Created by Filip Culig on 07.05.2022..
//

import AVKit
import Foundation
import SwiftUI

// MARK: - PlayerView -

struct PlayerView: UIViewRepresentable {
    let player: AVPlayer

    func updateUIView(_: UIView, context _: UIViewRepresentableContext<PlayerView>) {}

    func makeUIView(context _: Context) -> UIView {
        return PlayerUIView(player: player)
    }
}
