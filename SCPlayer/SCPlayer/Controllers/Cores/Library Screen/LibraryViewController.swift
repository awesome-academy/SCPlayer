//
//  LibraryViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit

final class LibraryViewController: UIViewController {

    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var libraryButton: UIButton!
    @IBOutlet private weak var underFavoritesButtonView: UIView!
    @IBOutlet private weak var underLibraryButtonView: UIView!
    @IBOutlet private weak var libraryCollectionView: UICollectionView!
    
    private var underLineViewStatus = true
    private var listFavoritesTrack = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "My Library"
        navigationItem.largeTitleDisplayMode = .always
        configureUnderButtonView(status: underLineViewStatus)
        configureLibraryCollectionView()
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
    
}

extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFavoritesTrack.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if underLineViewStatus {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TrackCollectionViewCell.self)
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AddPlaylistCollectionViewCell.self)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PlaylistCollectionViewCell.self)
                return cell
            }
        }
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Push View Controller
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
