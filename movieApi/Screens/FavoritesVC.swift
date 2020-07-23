//
//  FavoritesVC.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 20.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
    let dataSource = TableViewDataSource()
    
    override func viewDidLoad() {
        title = "Favorites"
        tableView.dataSource = dataSource
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupFavorites()
    }
    
    private func setupFavorites() {
        let allFavorites = FavoritesManager.getFavorites()
        switch allFavorites {
            case .success(let favorites):
                guard let favs = favorites else {
                    MovieApiAlertVC.showAlertHelper(title: "Favorites", message: Messages.noFavorites.rawValue, confirmationButtonText: "Ok", cancelButtonText: nil, viewController: self)
                    return
                }
                dataSource.favorites = favs
                tableView.reloadData()
            case .failure(let error):
                MovieApiAlertVC.showAlertHelper(title: "Favorites", message: error.rawValue, confirmationButtonText: "Ok", cancelButtonText: nil, viewController: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(DetailViewController(media: dataSource.favorites[indexPath.row], nibName: nil, bundle: nil), animated: true)
    }
}
