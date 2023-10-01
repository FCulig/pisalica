//
//  PlayerUIView.swift
//  edu-app
//
//  Created by Filip Culig on 07.05.2022..
//

import AVKit
import UIKit

// MARK: - PlayerUIView -

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    // MARK: - Initializers -

    init(player: AVPlayer) {
        super.init(frame: .zero)
        setupPlayer(with: player)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle -

    override func layoutSubviews() {
        super.layoutSubviews()
//        let view = UIView()
//        view.frame = bounds
//        view.backgroundColor = .red
//        addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
        playerLayer.frame = bounds
//        playerLayer.frame = .init(origin: .init(x: 280, y: 300), size: .init(width: 250, height: 250))
    }
}

// MARK: - Helper methods -

private extension PlayerUIView {
    func setupPlayer(with player: AVPlayer) {
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        playerLayer.player = player
        layer.addSublayer(playerLayer)
    }

    @objc func playerItemDidReachEnd(notification _: Notification) {
        playerLayer.player?.seek(to: CMTime.zero)
    }
}
