//
//  HomeTrackCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit
import Reusable

final class HomeTrackCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        mainImageView.layer.cornerRadius = 20
    }
    
    public func configureCell(track: Track) {
        guard let avatarUrlString = track.user?.avatarUrl else {
            return
        }
        setImage(urlString: avatarUrlString)
        songNameLabel.text = track.title
        artistLabel.text = track.user?.username
    }
    
    private func setImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let data = try? Data(contentsOf: url)
        guard let contentData = data else {
            return
        }
        mainImageView.image = UIImage(data: contentData)
    }
}
