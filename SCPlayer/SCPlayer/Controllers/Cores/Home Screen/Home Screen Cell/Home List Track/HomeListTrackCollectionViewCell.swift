//
//  HomeListTrackCollectionViewCell.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit
import Then
import Reusable

final class HomeListTrackCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var listTrackCollectionView: UICollectionView!
    
    let listTrack = [Track]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
        configureListTrackCollectionView()
    }
    
    public func configureCell() {
        
    }
    
    private func configureListTrackCollectionView() {
        listTrackCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: HomeTrackCollectionViewCell.self)
        }
    }
}

extension HomeListTrackCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTrack.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeTrackCollectionViewCell.self)
            return cell
    }
}

extension HomeListTrackCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Push PlayerViewController
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
