//
//  TrackAndPlaylistSettingViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 20/05/2021.
//

import UIKit

final class TrackAndPlaylistSettingViewController: UIViewController {
    
    @IBOutlet private weak var optionCollectionView: UICollectionView!
    
    private var selfListTrack = [Track]()
    private var selfTrackId = 0
    private var permalinkUrl = ""
    private var centerText = ""
    private var selfImageUrlString: String?
    private var isLiked = false
    private var listOption = [String]()
    private var isPlaylist = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        configureOptionCollectionView()
    }
    
    private func configureOptionCollectionView() {
        optionCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: DetailCollectionViewCell.self)
            $0.register(cellType: OptionCollectionViewCell.self)
        }
    }
    
    public func getDataPlaylist(playlistName: String, imageUrlString: String?, listTrack: [Track]) {
        centerText = playlistName
        selfImageUrlString = imageUrlString
        selfListTrack = listTrack
        isPlaylist = true
        listOption = ["Add songs", "Edit playlist", "Delete playlist", "Share"]
    }
    
    public func getDataTrack(trackId: Int, listTrack: [Track]) {
        let track = listTrack.first { $0.trackID == trackId }
        selfListTrack = listTrack
        selfTrackId = trackId
        selfImageUrlString = track?.user?.avatarUrl
        centerText = track?.title ?? ""
        permalinkUrl = track?.user?.permalinkUrl ?? ""
        listOption = ["Unlike", "Add to Playlist", "View Artist", "Share"]
        loadLikeStatus(trackId: trackId)
        isPlaylist = false
    }
    
    private func loadLikeStatus(trackId: Int) {
        let track = selfListTrack.first { $0.trackID == trackId }
        guard let track = track,
              let listIdLikedTrack = LikedTrackEntity.shared.getAllIdLikedTrack(),
              !listOption.isEmpty else {
            return
        }
        isLiked = listIdLikedTrack.contains(track.trackID ?? 0) ? true : false
        listOption[0] = isLiked ? "Like" : "Unlike"
    }
}

extension TrackAndPlaylistSettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOption.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DetailCollectionViewCell.self)
            cell.configure(imageUrlString: selfImageUrlString, label: centerText)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: OptionCollectionViewCell.self)
            cell.configure(optionString: listOption[indexPath.row - 1])
            return cell
        }
    }
}

extension TrackAndPlaylistSettingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isPlaylist {
            switch indexPath.row {
            case 1:
                let viewController = AddSongViewController()
                viewController.getData(playlistName: centerText, listTrack: selfListTrack)
                navigationController?.pushViewController(viewController, animated: true)
            case 2:
                let viewController = AddNewPlaylistViewController()
                viewController.getData(playlistName: centerText)
                navigationController?.pushViewController(viewController, animated: true)
            case 3:
                PlaylistEntity.shared.deletePlaylist(playlistName: centerText)
                navigationController?.popViewController(animated: true)
            default:
                print("Option Out of range")
            }
        } else {
            switch indexPath.row {
            case 1:
                if isLiked {
                    LikedTrackEntity.shared.deleteLikedTrack(trackId: selfTrackId)
                } else {
                    LikedTrackEntity.shared.insertNewLikedTrack(trackId: selfTrackId)
                }
                loadLikeStatus(trackId: selfTrackId)
                DispatchQueue.main.async {
                    self.optionCollectionView.reloadData()
                }
            case 2:
                let viewController = ListPlaylistViewController()
                viewController.getData(trackId: selfTrackId, listTrack: selfListTrack)
                navigationController?.pushViewController(viewController, animated: true)
            case 3:
                guard let url = URL(string: permalinkUrl) else { return }
                UIApplication.shared.open(url)
            default:
                print("Option Out of range")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let optionCellWidthSize: CGFloat = view.width - 20
        let optionCellHeightSize: CGFloat = 60
        let detailCellHeightSize: CGFloat = 330
        if indexPath.row == 0 {
            return CGSize(width: optionCellWidthSize, height: detailCellHeightSize)
        } else {
            return CGSize(width: optionCellWidthSize, height: optionCellHeightSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    }
}
