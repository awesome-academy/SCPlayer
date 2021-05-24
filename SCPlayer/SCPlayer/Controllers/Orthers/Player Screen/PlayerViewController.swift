//
//  PlayerViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit

final class PlayerViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    
    private var selfSongName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        let imageViewRadius = imageView.width * 0.5
        imageView.layer.cornerRadius = imageViewRadius
        title = selfSongName
        navigationItem.largeTitleDisplayMode = .never
    }
    
    public func loadData(track: Track) {
        selfSongName = track.title ?? ""
    }
}
