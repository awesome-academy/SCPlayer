//
//  TrackCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 19/05/2021.
//

import UIKit
import Reusable

final class TrackCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        songNameLabel.textColor = .black
        artistLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
}
