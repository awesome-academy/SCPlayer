//
//  TrackAndPlaylistSettingViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 20/05/2021.
//

import UIKit

final class TrackAndPlaylistSettingViewController: UIViewController {
    
    @IBOutlet private weak var optionCollectionView: UICollectionView!
    
    private var selfPlaylistName = String()
    private var selfImageUrlString: String?
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
    
    public func getDataPlaylist(playlistName: String, imageUrlString: String?) {
        selfPlaylistName = playlistName
        selfImageUrlString = imageUrlString
        isPlaylist = true
        listOption = ["Add songs", "Edit playlist", "Delete playlist", "Share"]
    }
    
    public func getDataTrack(track: Track) {
        listOption = ["Like", "Add to Playlist", "View Artist", "Share"]
    }
}

extension TrackAndPlaylistSettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOption.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DetailCollectionViewCell.self)
            cell.configure(imageUrlString: selfImageUrlString, label: selfPlaylistName)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: OptionCollectionViewCell.self)
            cell.configure(optionString: listOption[indexPath.row - 1])
            return cell
        }
    }
}

extension TrackAndPlaylistSettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension TrackAndPlaylistSettingViewController: UICollectionViewDelegateFlowLayout {
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
