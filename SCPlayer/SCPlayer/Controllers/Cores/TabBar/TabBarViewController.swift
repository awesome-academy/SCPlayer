//
//  TabBarViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        
        viewControllers = [
            configChildNavigationController(vc: HomeViewController(), item: TabbarItem.home.item),
            configChildNavigationController(vc: SearchViewController(), item: TabbarItem.search.item),
            configChildNavigationController(vc: LibraryViewController(), item: TabbarItem.library.item),
        ]
        setViewControllers(viewControllers, animated: true)
        
    }
    
    private func configChildNavigationController(vc: UIViewController, item: UITabBarItem) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
    
}
