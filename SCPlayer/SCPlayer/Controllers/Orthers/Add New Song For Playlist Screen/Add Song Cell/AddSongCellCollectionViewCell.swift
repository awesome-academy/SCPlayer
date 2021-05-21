//
//  AddSongCellCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 21/05/2021.
//

import UIKit
import Reusable

final class AddSongCellCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        songLabel.textColor = .black
        artistLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    public func configure(track: Track) {
        imageView.loadImage(urlString: track.user?.avatarUrl)
        songLabel.text = track.title
        artistLabel.text = track.user?.username
    }
}
