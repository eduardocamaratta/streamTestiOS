//
//  Player.swift
//  StreamApp
//
//  Copyright © 2019 Eduardo Camaratta. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerStatus: class {
    func metadataUpdated()
    func stateUpdated(playing: Bool)
}

class Player: NSObject {
    fileprivate let streamUrl = "https://stream.antenne.com/antenne-nds-80er/mp3-128/iPhoneApp"
    private let metadataKey = "timedMetadata"
    private let statusKey = "status"
    weak var delegate: PlayerStatus?
    var player: AVPlayer!
    var playing = false

    public func start() {
        guard let url = URL(string: self.streamUrl) else {return}
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        playerItem.addObserver(self, forKeyPath: self.statusKey, options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: self.metadataKey, options: .new, context: nil)
    }

    public func togglePlay() {
        if self.playing {
            self.player.pause()
        } else {
            self.player.play()
        }
        self.playing.toggle()
        self.delegate?.stateUpdated(playing: self.playing)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case self.statusKey:
            switch self.player.status {
            case .readyToPlay: self.togglePlay()
            case .failed: print("failed")
            case .unknown: print("unknown")
            }
        case self.metadataKey: self.delegate?.metadataUpdated()
        default: break;
        }
    }
}
