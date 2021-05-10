//
//  SearchViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit

final class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "Search"
        navigationItem.largeTitleDisplayMode = .always
    }


}
