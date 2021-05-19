//
//  PlaylistCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 19/05/2021.
//

import UIKit
import Reusable

final class PlaylistCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var playlistLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var optionButton: UIButton!
    
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
}
