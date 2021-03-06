//
//  PlaylistTrackCellCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 21/05/2021.
//

import UIKit
import Reusable

protocol PlaylistTrackCellCollectionViewCellDelegate: class {
    func pushMusicSettingViewController(trackId: Int)
}

final class PlaylistTrackCellCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var optionButton: UIButton!
    
    private var trackId = 0
    public weak var delegate: PlaylistTrackCellCollectionViewCellDelegate?
    
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
    
    public func configure(track: Track) {
        trackId = track.trackID ?? 0
        imageView.loadImage(urlString: track.user?.avatarUrl)
        songNameLabel.text = track.title
        artistLabel.text = track.user?.username
    }

    @IBAction func didTapOptionButton(_ sender: UIButton) {
        delegate?.pushMusicSettingViewController(trackId: trackId)
    }
}
