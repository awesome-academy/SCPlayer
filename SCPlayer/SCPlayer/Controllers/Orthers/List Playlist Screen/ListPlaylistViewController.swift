//
//  ListPlaylistViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 22/05/2021.
//

import UIKit

final class ListPlaylistViewController: UIViewController {

    @IBOutlet private weak var listPlaylistCollectionView: UICollectionView!
    
    private var listPlaylist = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
}

extension ListPlaylistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AddPlaylistCollectionViewCell.self)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ListPlaylistCollectionViewCell.self)
            return cell
        }
    }
}

extension ListPlaylistViewController: UICollectionViewDelegateFlowLayout {
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
