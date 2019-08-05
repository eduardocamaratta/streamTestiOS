//
//  ViewController.swift
//  StreamApp
//
//  Copyright © 2019 Eduardo Camaratta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PlayerStatus {

    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var loadingView: UIView!

    let player = Player()

    override func viewWillAppear(_ animated: Bool) {
        self.player.delegate = self
        self.loading(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.player.start()
    }

    // Shows the loading view
    func loading(_ loading: Bool) {
        self.loadingView.isHidden = !loading
        self.songTitleLabel.isHidden = loading
        self.artistNameLabel.isHidden = loading
        self.coverImage.isHidden = loading
    }

    // Fetches the current metadata and update the UI
    func updateMetadata() {
        MetadataService.getMetadata { (songTitle, artistName, itunesCoverUrl) in
            self.songTitleLabel.text = songTitle ?? "Failed to load song title :("
            self.artistNameLabel.text = artistName ?? "Failed to load artist name :("
            if let coverUrl = itunesCoverUrl {
                MetadataService.getImage(url: coverUrl, completion: { (data) in
                    if let imageData = data {
                        self.loadImage(data: imageData)
                    } else {
                        self.loadImage(data: nil)
                    }
                })
            } else {
                self.loadImage(data: nil)
            }
        }
    }

    // Load a cover image (or the default image) and disable the spinner
    func loadImage(data: Data?) {
        self.coverImage.image = data != nil ? UIImage(data: data!) : UIImage(named: "not_loaded")
        self.loading(false)
    }


    // --------------------------------------------------
    // MARK: Player Status Protocol
    // --------------------------------------------------
    
    func metadataUpdated() {
        self.loading(true)
        self.updateMetadata()
    }
}
