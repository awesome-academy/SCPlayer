//
//  SearchViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit

final class SearchViewController: UIViewController {
  
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchCollectionView: UICollectionView!
    
    private var searchCellWidthSize = CGFloat()
    private var searchCellHeightSize = CGFloat()
    private var listGenre = [String]()
    private var listTrack = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getDataFromAPI()
    }
    
    private func configure() {
        title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        searchCellWidthSize = view.width/2 - 30
        searchCellHeightSize = 100
        configureSearchButton()
        configureSearchCollectionView()
    }
    
    private func configureSearchButton() {
        searchButton.do {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            $0.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        }
    }
    
    private func configureSearchCollectionView() {
        searchCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: SearchByGenreCollectionViewCell.self)
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
        listGenre.insert("Favorites", at: 0)
        DispatchQueue.main.async {
            self.searchCollectionView.reloadData()
        }
    }
    
    private func getRandomColor() -> UIColor {
        let listSixColor: [UIColor] = [#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5808420083, green: 0.1048920423, blue: 0.1821678643, alpha: 1)]
        return listSixColor[Int.random(in: 0..<6)]
    }
    
    @objc private func didTapSearchButton() {
        let viewController = SearchResultsViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listGenre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchByGenreCollectionViewCell.self)
        cell.configureCell(genre: listGenre[indexPath.row], backgroundColor: getRandomColor())
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = SearchResultsViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: searchCellWidthSize, height: searchCellHeightSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20)
    }
}
