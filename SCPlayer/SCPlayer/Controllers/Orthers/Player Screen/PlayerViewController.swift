//
//  PlayerViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit

final class PlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .systemGreen
    }
    
    public func loadData(track: Track) {
        
    }
}
