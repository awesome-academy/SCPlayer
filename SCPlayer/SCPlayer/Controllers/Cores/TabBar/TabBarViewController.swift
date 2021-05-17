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
            configChildNavigationController(viewController: HomeViewController(), item: TabbarItem.home.item),
            configChildNavigationController(viewController: SearchViewController(), item: TabbarItem.search.item),
            configChildNavigationController(viewController: LibraryViewController(), item: TabbarItem.library.item)
        ]
        setViewControllers(viewControllers, animated: true)
    }
    
    private func configChildNavigationController(viewController: UIViewController, item: UITabBarItem) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = item
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
