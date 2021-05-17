//
//  SearchResultsViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 17/05/2021.
//

import UIKit

final class SearchResultsViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchResultsCollectionView: UICollectionView!
    
    private var listTrackResult = [Track]()
    private var listTrack = [Track]()
    private var selfGenre = String()
    private var listTempDataForSearch = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        configureSearchBar()
        configureResultsCollectionView()
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Search your songs ..."
        searchBar.delegate = self
    }
    
    private func configureResultsCollectionView() {
        searchResultsCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: SearchResultsCellCollectionViewCell.self)
        }
    }
    
    private func searchByText(text: String) {
        listTrackResult.removeAll()
        listTrackResult = listTempDataForSearch.filter { $0.title?.lowercased().contains(text.lowercased()) ?? false
        }
        if text.isEmpty {
            listTrackResult = listTempDataForSearch
        }
        DispatchQueue.main.async {
            self.searchResultsCollectionView.reloadData()
        }
    }
    
    private func loadData(genre: String) {
        switch genre {
        case "All Songs":
            listTrackResult.removeAll()
            listTrackResult = listTrack
        case "Favorites":
            listTrackResult.removeAll()
        default:
            listTrackResult.removeAll()
            listTrackResult = listTrack.filter { $0.genre == genre }
        }
        listTempDataForSearch = listTrackResult
    }
    
    public func getData(genre: String, allTrack: [Track]) {
        listTrack = allTrack
        selfGenre = genre
        loadData(genre: selfGenre)
    }
}

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTrackResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchResultsCellCollectionViewCell.self)
        cell.configure(track: listTrackResult[indexPath.row])
        return cell
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = PlayerViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
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

extension SearchResultsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchByText(text: searchText)
    }
}
