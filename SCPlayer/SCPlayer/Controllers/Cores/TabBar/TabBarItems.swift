//
//  TabBarItems.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import Foundation
import UIKit

enum TabbarItem {
    
    case home
    case search
    case library
    
    var item: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        case .search:
            return UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        case .library:
            return UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        }
    }
}
