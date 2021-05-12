//
//  HomeViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit
import Then
import Reusable

final class HomeViewController: UIViewController {

    @IBOutlet private weak var homeCollectionView: UICollectionView!
    
    private var listGenre = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureHomeCollectionView()
    }
    
    private func configure() {
        title = "Home"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureHomeCollectionView() {
        homeCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: HomeGenreLabelCollectionViewCell.self)
            $0.register(cellType: HomeListTrackCollectionViewCell.self)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listGenre.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeGenreLabelCollectionViewCell.self)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeListTrackCollectionViewCell.self)
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Size Of Cell
        let labelCellSize = CGSize(width: view.width, height: 60)
        let listTrackCellSize = CGSize(width: view.width, height: 230)
        
        if indexPath.row % 2 == 0 {
            return labelCellSize
        }
        return listTrackCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
