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
            [weak self] result in
            guard let self = self else { return }
            guard let apiResult = result else {
                #warning("show alert messaging about an network error")
                print("Cannot get specific media from the API")
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
}
