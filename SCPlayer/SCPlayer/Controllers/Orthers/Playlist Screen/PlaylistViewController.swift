//
//  PlaylistViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 19/05/2021.
//

import UIKit

final class PlaylistViewController: UIViewController {
    
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var addSongButton: UIButton!
    @IBOutlet private weak var listTrackCollectionView: UICollectionView!
    
    private var selfPlaylistName = ""
    private var listTrackId = [Int]()
    private var selfListTrack = [Track]()
    private var listTrackResult = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        DispatchQueue.main.async {
            self.listTrackCollectionView.reloadData()
        }
    }
    
    @IBAction func didTapPlayPauseButton(_ sender: UIButton) {
        // Play Songs in Playlist
    }
    
    @IBAction func didTapAddSongButton(_ sender: UIButton) {
        let viewController = AddSongViewController()
        viewController.getData(playlistName: selfPlaylistName, listTrack: selfListTrack)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func configure() {
        let playPauseButtonRadius = playPauseButton.width * 0.5
        playPauseButton.layer.cornerRadius = playPauseButtonRadius
        addSongButton.layer.cornerRadius = 20
        title = selfPlaylistName
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        configureListTrackCollectionView()
    }
    
    private func configureListTrackCollectionView() {
        listTrackCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: PlaylistTrackCellCollectionViewCell.self)
        }
    }
    
    public func getData(playlistName: String, listTrack: [Track]) {
        selfListTrack = listTrack
        listTrackResult = listTrack
        selfPlaylistName = playlistName
        loadData()
    }
    
    private func loadData() {
        listTrackId = TrackEntity.shared.getAllTrackIdInPlaylist(playlistName: selfPlaylistName) ?? []
        listTrackResult = selfListTrack.filter { listTrackId.contains($0.trackID ?? 0) }
    }
}

extension PlaylistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTrackResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PlaylistTrackCellCollectionViewCell.self)
        cell.configure(track: listTrackResult[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = PlayerViewController()
        viewController.loadData(track: listTrackResult[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
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

extension PlaylistViewController: PlaylistTrackCellCollectionViewCellDelegate {
    func pushMusicSettingViewController(trackId: Int) {
        let viewController = TrackAndPlaylistSettingViewController()
        viewController.getDataTrack(trackId: trackId, listTrack: listTrackResult)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
