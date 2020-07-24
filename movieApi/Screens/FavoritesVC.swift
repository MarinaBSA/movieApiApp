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
        let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAllFavorites))
        removeButton.tintColor = UIColor.label
        navigationItem.rightBarButtonItem = removeButton
        
        setupFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showFavorites()
    }
    
    private func setupFavorites() {
        let allFavorites = FavoritesManager.getFavorites()
        switch allFavorites {
            case .success(let favorites):
                guard let favs = favorites else {
                    MovieApiAlertViewController.showAlertHelper(title: "Favorites", message: Messages.noFavorites.rawValue, confirmationButtonText: "Ok", cancelButtonText: nil, viewController: self)
                    return
                }
                dataSource.favorites = favs
                tableView.reloadData()
            case .failure(let error):
                MovieApiAlertViewController.showAlertHelper(title: "Favorites", message: error.rawValue, confirmationButtonText: "Ok", cancelButtonText: nil, viewController: self)
        }
    }
    
    private func showFavorites() {
        let allFavorites = FavoritesManager.getFavorites()
        switch allFavorites {
            case .success(let favorites):
                if let favs = favorites {
                    dataSource.favorites = favs
                    tableView.reloadData()
                }
            case .failure(let error):
                MovieApiAlertViewController.showAlertHelper(title: "Favorites", message: error.rawValue, confirmationButtonText: "Ok", cancelButtonText: nil, viewController: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(DetailViewController(media: dataSource.favorites[indexPath.row], nibName: nil, bundle: nil), animated: true)
    }
    
        
    @objc private func removeAllFavorites() {
        guard !dataSource.favorites.isEmpty else { return }
        showRemoveAlert()
    }
    
    private func showRemoveAlert() {
        let alert = UIAlertController(title: "Warning", message: "Do you want to delete all your saved favorites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) {
            [weak self] _ in
            self?.dataSource.favorites.removeAll()
            FavoritesManager.updateFavorites(with: []) {
                [weak self] error in
                guard let passedError = error else {
                    self?.tableView.reloadData()
                    return
                }
                print(passedError.rawValue)
            }
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
    }
}
