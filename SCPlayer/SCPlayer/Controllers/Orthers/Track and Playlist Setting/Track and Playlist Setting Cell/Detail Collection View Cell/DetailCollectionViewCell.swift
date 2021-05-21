//
//  DetailCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 20/05/2021.
//

import UIKit
import Reusable

final class DetailCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var centerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        imageView.layer.cornerRadius = 20
    }
    
    public func configure(imageUrlString: String?, label: String) {
        imageView.loadImage(urlString: imageUrlString)
        centerLabel.text = label
    }
}
