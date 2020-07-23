//
//  TableViewDataSource.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 20.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    var favorites = [MediaItem]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseID, for: indexPath) as! TableViewCell
        let fav = favorites[indexPath.row]
        cell.textLabel?.text = fav.title
         NetworkManager().getImage(mediaURL: fav.poster) {
            image in
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        }
        return cell
    }
    
    #warning("fix this")
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        favorites.remove(at: indexPath.row)
        FavoritesManager.defaults.removeObject(forKey: "movie-\(indexPath.row)")
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
