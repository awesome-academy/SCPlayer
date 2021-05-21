//
//  HomeTrackCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit
import Reusable

final class HomeTrackCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        mainImageView.layer.cornerRadius = 20
    }
    
    public func configureCell(track: Track) {
        mainImageView.loadImage(urlString: track.user?.avatarUrl)
        songNameLabel.text = track.title
        artistLabel.text = track.user?.username
    }
}
