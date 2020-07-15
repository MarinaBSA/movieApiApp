//
//  ViewController.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

enum Section {
    case main
}

class ViewController: UIViewController {

    let baseURL = "https://www.omdbapi.com/?apikey=b78d8af3"
    var cells = [MediaItem]()
    var collection: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MediaItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, MediaItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
        
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.setValue("Search", forKey: "cancelButtonText")
        navigationItem.searchController?.searchBar.placeholder = "Enter a movie or series"
        
        collection = setupCollectionView()
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        collection.dataSource = dataSource
        collection.backgroundColor = .systemBackground
        collection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupCollectionView() -> UICollectionView {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let width = view.frame.width
        let margin:CGFloat = 25
        let itemSize:CGFloat = width - 2*margin
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize + 50)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionViewLayout.minimumLineSpacing = 40
        return UICollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)
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
            cell.setLabels(title: media.title, year: media.year)
            return cell
        })
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func getMovies(title: String, year: Int?) -> ApiResult? {
        let url = URL(string: "\(baseURL)&s=\(title)")!
    
        let jsonDecoder = JSONDecoder()
        do {
            let movieData = try Data(contentsOf: url)
            do {
                let result = try jsonDecoder.decode(ApiResult.self, from: movieData)
                return result
            } catch {
                print(error as Any)
                print("Cannot decode JSON. Error: \(error.localizedDescription)")
            }
        } catch {
            print("Cannot get this movie's information. Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func showMedia(media: [Media]) {
        if !cells.isEmpty { cells.removeAll(keepingCapacity: true) }
        for item in media {
            #warning("get this out of here")
            cells.append(MediaItem(title: item.Title, plot: nil, year: item.Year, id: item.imdbID))
        }
        snapshot = createCollectionViewsSnapshot(cells: cells)
        updateCollectionView()
    }
    
    private func updateResults(searchText: String) {
        if let result = getMovies(title: searchText, year: nil) {
            showMedia(media: result.Search)
            title = "Results"
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty)! else { return }
        updateResults(searchText: searchBar.text!)
    }
}

extension ViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty)! else { return }
        updateResults(searchText: searchBar.text!)
    }
}


