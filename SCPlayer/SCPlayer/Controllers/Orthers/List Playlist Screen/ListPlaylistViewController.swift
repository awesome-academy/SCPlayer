//
//  ListPlaylistViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 22/05/2021.
//

import UIKit

final class ListPlaylistViewController: UIViewController {

    @IBOutlet private weak var listPlaylistCollectionView: UICollectionView!
    
    private var selfListTrack = [Track]()
    private var listPlaylist = [String]()
    private var selfTrackId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getListPlaylist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListPlaylist()
    }
    
    private func configure() {
        configureListPlaylistCollectionView()
    }
    
    private func configureListPlaylistCollectionView() {
        listPlaylistCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: AddPlaylistCollectionViewCell.self)
            $0.register(cellType: ListPlaylistCollectionViewCell.self)
        }
    }
    
    public func getData(trackId: Int, listTrack: [Track]) {
        selfListTrack = listTrack
        selfTrackId = trackId
    }
    
    private func getListPlaylist() {
        listPlaylist = PlaylistEntity.shared.getAllPlaylist() ?? []
        DispatchQueue.main.async {
            self.listPlaylistCollectionView.reloadData()
        }
    }
    
    private func getNumberOfSongInPlaylist(playlistName: String) -> Int {
        return TrackEntity.shared.getAllTrackIdInPlaylist(playlistName: playlistName)?.count ?? 0
    }
    
    private func getImageOfFirstTrackInPlaylist(playlistName: String) -> String? {
        let listId = TrackEntity.shared.getAllTrackIdInPlaylist(playlistName: playlistName) ?? []
        let track = selfListTrack.first { $0.trackID == listId.first }
        return track?.user?.avatarUrl
    }
}

extension ListPlaylistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPlaylist.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AddPlaylistCollectionViewCell.self)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ListPlaylistCollectionViewCell.self)
            let numberOfTrack = getNumberOfSongInPlaylist(playlistName: listPlaylist[indexPath.row - 1])
            let imageUrlString = getImageOfFirstTrackInPlaylist(playlistName: listPlaylist[indexPath.row - 1])
            cell.configure(playlistName: listPlaylist[indexPath.row - 1], numberOfTrack: numberOfTrack, imageUrlString: imageUrlString)
            return cell
        }
    }
}

extension ListPlaylistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewController = AddNewPlaylistViewController()
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let idRow = "\(selfTrackId).\(listPlaylist[indexPath.row - 1])"
            TrackEntity.shared.insertNewTrack(idRow: idRow,
                                              trackId: selfTrackId,
                                              playlistName: listPlaylist[indexPath.row - 1])
            navigationController?.popViewController(animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let resultCellWidthSize: CGFloat = view.width - 20
        let resultCellHeightSize: CGFloat = 100
        return CGSize(width: resultCellWidthSize, height: resultCellHeightSize )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    }
}
