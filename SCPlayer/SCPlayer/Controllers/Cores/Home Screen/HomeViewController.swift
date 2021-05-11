//
//  HomeViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
    
    private func configure() {
        title = "Home"
        navigationItem.largeTitleDisplayMode = .always
    }
    private func loadData() {
        let shared = APIServices()
        shared.fetchTracksJSON { [unowned self] (result) in
            switch result {
            case .success(let courses):
                for item in courses {
                    print(item.user?.username)
                }
            case .failure(let error):
                print("Failed to fetch Courses \(error)")
            }
        }
    }
}
