//
//  LibraryViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit

final class LibraryViewController: UIViewController {

    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var playlistButton: UIButton!
    @IBOutlet private weak var underFavoritesButtonView: UIView!
    @IBOutlet private weak var underLibraryButtonView: UIView!
    @IBOutlet private weak var libraryCollectionView: UICollectionView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private var isFavoritesButton = true
    private var listLikedTrack = [Track]()
    private var listTrack = [Track]()
    private var listPlaylist = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getDataFromAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listLikedTrack = loadLikedStatusData(tracks: listTrack)
        loadListPlaylist()
        DispatchQueue.main.async {
            self.libraryCollectionView.reloadData()
        }
    }
    
    private func configure() {
        spinner.startAnimating()
        title = "My Library"
        navigationItem.largeTitleDisplayMode = .always
        configureUnderButtonView(status: isFavoritesButton)
        configureLibraryCollectionView()
        favoritesButton.addTarget(self, action: #selector(didTapFavoritesButton), for: .touchUpInside)
        playlistButton.addTarget(self, action: #selector(didTapPlaylistButton), for: .touchUpInside)
    }
    
    private func configureUnderButtonView(status: Bool) {
        underLibraryButtonView.isHidden = status
        underFavoritesButtonView.isHidden = !status
    }
    
    private func configureLibraryCollectionView() {
        libraryCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: TrackCollectionViewCell.self)
            $0.register(cellType: AddPlaylistCollectionViewCell.self)
            $0.register(cellType: PlaylistCollectionViewCell.self)
        }
    }
    
    @objc private func didTapFavoritesButton() {
        isFavoritesButton = true
        configureUnderButtonView(status: isFavoritesButton)
        DispatchQueue.main.async {
            self.libraryCollectionView.reloadData()
        }
    }
    
    @objc private func didTapPlaylistButton() {
        isFavoritesButton = false
        configureUnderButtonView(status: isFavoritesButton)
        DispatchQueue.main.async {
            self.libraryCollectionView.reloadData()
        }
    }
    
    private func getDataFromAPI() {
        APIServices.shared.fetchTracksJSON { [unowned self] result in
            switch result {
            case .success(let tracks):
                self.loadData(tracks: tracks)
            case .failure(let error):
                print("Failed to fetch Tracks: \(error)")
            }
        }
    }
    
    private func loadData(tracks: [Track]) {
        listTrack = tracks
        listLikedTrack = loadLikedStatusData(tracks: listTrack)
        loadListPlaylist()
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.libraryCollectionView.reloadData()
        }
    }
    
    private func loadLikedStatusData(tracks: [Track]) -> [Track] {
        guard let listLikedTrackId = LikedTrackEntity.shared.getAllIdLikedTrack() else {
            return []
        }
        let listTrack = tracks.map { track in
            return track.with { $0.isLiked = listLikedTrackId.contains($0.trackID ?? 0) }
        }.filter { $0.isLiked }
        return listTrack
    }
    
    private func loadListPlaylist() {
        listPlaylist = PlaylistEntity.shared.getAllPlaylist() ?? []
    }
    
    private func getNumberOfSongInPlaylist(playlistName: String) -> Int {
        return TrackEntity.shared.getAllTrackIdInPlaylist(playlistName: playlistName)?.count ?? 0
    }
    
    private func getImageOfFirstTrackInPlaylist(playlistName: String) -> String? {
        let listId = TrackEntity.shared.getAllTrackIdInPlaylist(playlistName: playlistName) ?? []
        let track = listTrack.first { $0.trackID == listId.first }
        return track?.user?.avatarUrl
    }
}

extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFavoritesButton {
            return listLikedTrack.count
        } else {
            return listPlaylist.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFavoritesButton {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TrackCollectionViewCell.self)
            cell.configure(track: listLikedTrack[indexPath.row])
            cell.delegate = self
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AddPlaylistCollectionViewCell.self)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PlaylistCollectionViewCell.self)
                let numberOfTrack = getNumberOfSongInPlaylist(playlistName: listPlaylist[indexPath.row - 1])
                let imageUrlString = getImageOfFirstTrackInPlaylist(playlistName: listPlaylist[indexPath.row - 1])
                cell.configure(playlistName: listPlaylist[indexPath.row - 1], numberOfTrack: numberOfTrack, imageUrlString: imageUrlString)
                cell.delegate = self
                return cell
            }
        }
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFavoritesButton {
            let viewController = PlayerViewController()
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            
            if indexPath.row == 0 {
                let viewController = AddNewPlaylistViewController()
                navigationController?.pushViewController(viewController, animated: true)
            } else {
                let viewController = PlaylistViewController()
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension LibraryViewController: UICollectionViewDelegateFlowLayout {
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

extension LibraryViewController: TrackCollectionViewCellDelegate {
    func reloadCollectionView() {
        listLikedTrack = loadLikedStatusData(tracks: listTrack)
        DispatchQueue.main.async {
            self.libraryCollectionView.reloadData()
        }
    }
}

extension LibraryViewController: PlaylistCollectionViewCellDelegate {
    func pushViewController(playlistName: String, playlistImageString: String?) {
        let viewController = TrackAndPlaylistSettingViewController()
        viewController.getDataPlaylist(playlistName: playlistName, imageUrlString: playlistImageString)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
