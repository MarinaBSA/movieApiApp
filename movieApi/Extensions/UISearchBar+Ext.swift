//
//  UISearchBar+Ext.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 16.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

extension SearchController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty)! else { return }
        self.page = 1
        self.searchKeyword = searchBar.text!
        self.updateResults(searchText: self.searchKeyword)
        dismiss(animated: true)
    }
}
