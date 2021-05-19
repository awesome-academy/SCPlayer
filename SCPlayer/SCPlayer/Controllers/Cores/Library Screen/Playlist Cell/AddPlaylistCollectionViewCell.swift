//
//  AddPlaylistCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 19/05/2021.
//

import UIKit
import Reusable

final class AddPlaylistCollectionViewCell: UICollectionViewCell, NibReusable {

    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        contentView.backgroundColor = #colorLiteral(red: 0.8518963057, green: 0.8518963057, blue: 0.8518963057, alpha: 1)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        contentView.layer.cornerRadius = 20
    }

}
