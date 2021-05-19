//
//  SearchResultsCellCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 17/05/2021.
//

import UIKit
import Reusable

protocol SearchResultsCellCollectionViewCellDelegate: class {
    func reloadCollectionView(trackID: Int)
}

final class SearchResultsCellCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    private var trackId = 0
    private var isLiked = false
    public weak var delegate: SearchResultsCellCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }
    
    private func initCell() {
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        songNameLabel.textColor = .black
        artistLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }
    
    @objc private func didTapLikeButton() {
        if isLiked {
            TrackDatabase.shared.delete(trackId: trackId)
        } else {
            TrackDatabase.shared.insert(trackId: trackId)
        }
        delegate?.reloadCollectionView(trackID: trackId)
    }
    
    public func configure(track: Track) {
        trackId = track.trackID ?? 0
        isLiked = track.isLiked
        imageView.loadImage(urlString: track.user?.avatarUrl)
        songNameLabel.text = track.title
        artistLabel.text = track.user?.username
        if track.isLiked {
            likeButton.setImage(UIImage(named: "likeHeart"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "unLikeHeart"), for: .normal)
        }
    }
}
