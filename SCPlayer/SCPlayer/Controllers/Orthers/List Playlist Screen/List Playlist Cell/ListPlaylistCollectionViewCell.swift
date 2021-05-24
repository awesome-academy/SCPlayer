//
//  ListPlaylistCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 24/05/2021.
//

import UIKit
import Reusable

final class ListPlaylistCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var playlistLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        playlistLabel.textColor = .black
        countLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    public func configure(playlistName: String, numberOfTrack: Int, imageUrlString: String?) {
        imageView.loadImage(urlString: imageUrlString)
        playlistLabel.text = playlistName
        countLabel.text = "\(numberOfTrack) \(numberOfTrack <= 1 ? "Song" : "Songs")"
    }
}
