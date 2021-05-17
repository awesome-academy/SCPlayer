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
    private var listTrack = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureHomeCollectionView()
        getDataFromAPI()
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
        listGenre.removeAll()
        listGenre = listTrack.map { $0.genre ?? "NIL" }
            .filter { $0 != "NIL" && $0 != "" }
        listGenre.insert("All Songs", at: 0)
        DispatchQueue.main.async {
            self.homeCollectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellNumber = listGenre.count * 2
        return cellNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeGenreLabelCollectionViewCell.self)
            cell.configureCell(genre: listGenre[indexPath.row / 2])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeListTrackCollectionViewCell.self)
            let genre = listGenre[(indexPath.row - 1) / 2]
            cell.getData(genre: genre, listTrack: listTrack)
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelCellSize = CGSize(width: view.width, height: 60)
        let listTrackCellSize = CGSize(width: view.width, height: 230)
        let listAllTrackCellSize = CGSize(width: view.width, height: 460)
        if indexPath.row % 2 == 0 {
            return labelCellSize
        } else if indexPath.row == 1 {
            return listAllTrackCellSize
        }
        return listTrackCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
