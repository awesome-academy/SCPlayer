//
//  PlaylistCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 19/05/2021.
//

import UIKit
import Reusable

protocol PlaylistCollectionViewCellDelegate: class {
    func pushViewController(playlistName: String, playlistImageString: String?)
}

final class PlaylistCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var playlistLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var optionButton: UIButton!
    
    private var selfPlaylistName = String()
    private var selfPlaylitImageString: String?
    public weak var delegate: PlaylistCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        playlistLabel.textColor = .black
        countLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        optionButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
    }
    
    @objc private func didTapOptionButton() {
        delegate?.pushViewController(playlistName: selfPlaylistName, playlistImageString: selfPlaylitImageString)
    }
    
    public func configure(playlistName: String, numberOfTrack: Int, imageUrlString: String?) {
        selfPlaylistName = playlistName
        selfPlaylitImageString = imageUrlString
        imageView.loadImage(urlString: imageUrlString)
        playlistLabel.text = playlistName
        countLabel.text = "\(numberOfTrack) \(numberOfTrack <= 1 ? "Song" : "Songs")"
    }
}
