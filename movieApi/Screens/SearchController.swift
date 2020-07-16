//
//  SearchController.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

enum Section {
    case main
}

class SearchController: UIViewController {
    
    let searchController = UISearchController()
    var cells = [MediaItem]()
    var collection: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MediaItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, MediaItem>!
    static var imageCache = NSCache<NSString, UIImage>()
    let networkHandler = NetworkHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupCollectionView()
    }
    
    private func setupSearchController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.setValue("Search", forKey: "cancelButtonText")
        navigationItem.searchController?.searchBar.placeholder = "Enter a movie or series"
    }
    
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let width = view.frame.width
        let margin:CGFloat = 25
        let itemSize:CGFloat = width - 2*margin
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize + 50)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionViewLayout.minimumLineSpacing = 40
        collection = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)
        
        collection.backgroundColor = .none
        collection.delegate = self
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        collection.dataSource = dataSource
        collection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func createCollectionViewsSnapshot(cells: [MediaItem]) -> NSDiffableDataSourceSnapshot<Section, MediaItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MediaItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cells)
        return snapshot
    }
    
    private func updateCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Section, MediaItem>(collectionView: collection, cellProvider: {
            (collection, indexPath, media) -> UICollectionViewCell? in
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as? CollectionViewCell else {
                fatalError("Cannot dequeue custom cell")
            }
            cell.spinner = cell.startSpinner(nil)
            cell.setLabels(title: media.title, year: media.year, imageURL: media.poster)
            return cell
        })
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showMedia(media: [Media]) {
        cells = media.map({ MediaItem(title: $0.Title, plot: nil, year: $0.Year, id: $0.imdbID, poster: $0.Poster) })
        snapshot = createCollectionViewsSnapshot(cells: cells)
        updateCollectionView()
    }
    
    func updateResults(searchText: String) {
        let spinner = view.startSpinner(nil)
        networkHandler.getAllMedia(withTitle: searchText, fromYear: nil) {
            [weak self] result in
            guard let self = self else { return }
            guard let apiResult = result else {
                print("Cannot get all media from the API")
                #warning("show alert messaging about an network error")
                return
            }
            DispatchQueue.main.async {
                self.showMedia(media: apiResult.Search)
                self.title = "Results"
                spinner.stopAnimating()
            }
        }
    }
}





