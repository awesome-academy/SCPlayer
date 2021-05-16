//
//  SearchByGenreCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 16/05/2021.
//

import UIKit
import Reusable

final class SearchByGenreCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        genreLabel.textColor = .white
        contentView.layer.cornerRadius = 20
    }
    
    public func configureCell(genre: String, backgroundColor: UIColor) {
        genreLabel.text = genre
        contentView.backgroundColor = backgroundColor
    }
}
