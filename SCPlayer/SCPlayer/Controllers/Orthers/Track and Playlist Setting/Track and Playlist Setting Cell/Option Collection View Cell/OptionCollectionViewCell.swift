//
//  OptionCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 20/05/2021.
//

import UIKit
import Reusable

final class OptionCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(optionString: String) {
        imageView.image = UIImage(named: optionString)
        imageView.contentMode = .scaleAspectFit
        optionLabel.text = optionString
    }
}
