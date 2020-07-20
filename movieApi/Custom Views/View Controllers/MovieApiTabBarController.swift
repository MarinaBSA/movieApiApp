//
//  MovieApiTabBarController.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 20.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class MovieApiTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createSearchNC(), createFavoritesNC()]
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesVC)
    }
}
