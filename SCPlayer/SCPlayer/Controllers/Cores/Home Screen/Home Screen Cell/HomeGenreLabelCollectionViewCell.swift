//
//  HomeGenreLabelCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit
import Reusable

final class HomeGenreLabelCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureCell(genre: String) {
        genreLabel.text = genre
    }
}
