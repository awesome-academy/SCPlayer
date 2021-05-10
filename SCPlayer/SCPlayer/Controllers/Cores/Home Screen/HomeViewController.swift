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
    }
    
    private func configure() {
        title = "Home"
        navigationItem.largeTitleDisplayMode = .always
    }

}
