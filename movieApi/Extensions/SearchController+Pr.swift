//
//  UISearchController+Pr.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 17.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import Foundation

extension SearchController: AlertButtonProcol {
    func confirmAction() {
        self.view.removeFromSuperview()
    }
    
    func cancelAction() {}
    
}
