//
//  UICollectionView+Ext.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 16.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMedia = cells[indexPath.item]
        let spinner = collectionView.cellForItem(at: indexPath)!.startSpinner(nil)
        self.networkHandler.getMedia(id: selectedMedia.id) {
            [weak self] result, error in
            guard let self = self else { return }
            guard let apiResult = result, error == nil else {
                MovieApiAlertVC.showAlertHelper(title: "Error",
                                                message: error!.rawValue,
                                     confirmationButtonText: "Ok",
                                     cancelButtonText: nil, viewController: self)
                return
            }
            DispatchQueue.main.async {
                let vc = DetailViewController(mediaTitle: apiResult.Title, year: apiResult.Year,
                                              plot: apiResult.Plot, imageURL: apiResult.Poster, nibName: nil, bundle: nil)
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
                spinner.stopAnimating()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let viewHeight = view.bounds.height
        let scrollViewHeight = scrollView.contentSize.height
        if scrollViewHeight > viewHeight, offset + viewHeight > scrollViewHeight + 200 {
            if let text = self.searchController.searchBar.text, text.isEmpty {
                MovieApiAlertVC.showAlertHelper(title: "Warning",
                    message: "Insert the desired keyword in the search bar at the top in order to see more results on that keyword.",
                    confirmationButtonText: "Ok",
                    cancelButtonText: nil, viewController: self)
                return
            }
            self.page += 1
            self.updateResults(searchText: self.searchController.searchBar.text!)
        }
    }
    
   
}
