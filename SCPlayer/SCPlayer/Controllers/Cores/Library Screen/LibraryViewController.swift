//
//  LibraryViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit

final class LibraryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "Library"
        navigationItem.largeTitleDisplayMode = .always
    }
}
