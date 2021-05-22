//
//  AddSongViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 20/05/2021.
//

import UIKit

final class AddSongViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var listTrackCollectionView: UICollectionView!
    
    private var selfPlaylistName = String()
    private var selfListTrack = [Track]()
    private var listTempDataForSearch = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureSearchBar()
        configureListTrackCollectionView()
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Search your songs ..."
        searchBar.delegate = self
    }
    
    private func configureListTrackCollectionView() {
        listTrackCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: AddSongCellCollectionViewCell.self)
        }
    }
    
    private func searchByText(text: String) {
        selfListTrack.removeAll()
        selfListTrack = listTempDataForSearch.filter { $0.title?.lowercased().contains(text.lowercased()) ?? false
        }
        if text.isEmpty {
            selfListTrack = listTempDataForSearch
        }
        DispatchQueue.main.async {
            self.listTrackCollectionView.reloadData()
        }
    }
    
    public func getData(playlistName: String, listTrack: [Track]) {
        selfPlaylistName = playlistName
        selfListTrack = listTrack
        listTempDataForSearch = listTrack
    }
}

extension AddSongViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selfListTrack.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AddSongCellCollectionViewCell.self)
        cell.configure(track: selfListTrack[indexPath.row])
        return cell
    }
}

extension AddSongViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let trackId = selfListTrack[indexPath.row].trackID ?? 0
        let idRow = "\(trackId).\(selfPlaylistName)"
        TrackEntity.shared.insertNewTrack(idRow: idRow, trackId: trackId, playlistName: selfPlaylistName)
        navigationController?.popViewController(animated: true)
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

extension AddSongViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchByText(text: searchText)
    }
}
