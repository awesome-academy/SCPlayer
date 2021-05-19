//
//  HomeListTrackCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit
import Then
import Reusable

protocol HomeListTrackCollectionViewCellDelegate: class {
    func pushViewController(track: Track)
}

final class HomeListTrackCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var listTrackCollectionView: UICollectionView!
    
    private var listAllTrack = [Track]()
    private var selfGenre = String()
    private var listTrackForGenre = [Track]()
    public weak var delegate: HomeListTrackCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        configureListTrackCollectionView()
        loadData()
    }
    
    private func configureListTrackCollectionView() {
        listTrackCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: HomeTrackCollectionViewCell.self)
        }
    }
    
    public func getData (genre: String, listTrack: [Track]) {
        listAllTrack = listTrack
        selfGenre = genre
        loadData()
    }
    
    private func loadData() {
        if selfGenre == "All Songs" {
            listTrackForGenre = listAllTrack
        } else {
            listTrackForGenre.removeAll()
            listTrackForGenre = listAllTrack.filter { $0.genre == selfGenre }
        }
        DispatchQueue.main.async {
            self.listTrackCollectionView.reloadData()
        }
    }
}

extension HomeListTrackCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTrackForGenre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeTrackCollectionViewCell.self)
        cell.configureCell(track: listTrackForGenre[indexPath.row])
        return cell
    }
}

extension HomeListTrackCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushViewController(track: listTrackForGenre[indexPath.row])
    }
}

extension HomeListTrackCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let trackCellSize = CGSize(width: 170, height: 230)
        return trackCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
