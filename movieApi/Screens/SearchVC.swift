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

class SearchViewController: UIViewController {
    
    let searchController = UISearchController()
    let networkHandler = NetworkManager()
    var cells = [MediaItem]()
    var collection: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MediaItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, MediaItem>!
    var page = 1
    var searchKeyword: String!
    static var imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSearchController()
        setupCollectionView()
    }
    
    private func setupSearchController() {
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.setValue("Search", forKey: "cancelButtonText")
        navigationItem.searchController?.searchBar.placeholder = "Enter a movie or series"
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeResultsFromPage))
        navigationItem.setRightBarButton(removeButton, animated: true)
        removeButton.tintColor = UIColor.label
    }
    
    private func setupCollectionView() {
        configureCollectionViewLayout()
        configureCollectionView()
        layoutCollectionView()
    }
    
    private func configureCollectionViewLayout() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let width = view.frame.width
        let margin:CGFloat = 25
        let itemSize:CGFloat = width - 2*margin
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize + 50)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionViewLayout.minimumLineSpacing = 40
        collection = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)
    }
    
    private func configureCollectionView() {
        collection.backgroundColor = .none
        collection.delegate = self
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        collection.dataSource = dataSource
        collection.translatesAutoresizingMaskIntoConstraints = false
        setupDataSource()
        view.addSubview(collection)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MediaItem>(collectionView: collection, cellProvider: {
            (collection, indexPath, media) -> UICollectionViewCell? in
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as? CollectionViewCell else {
                fatalError("Cannot dequeue custom cell")
            }
            cell.spinner = cell.startSpinner(nil)
            cell.setLabels(title: media.title, year: media.year, imageURL: media.poster)
            return cell
        })
    }
    
    private func layoutCollectionView() {
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
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showMedia(media: [Media]) {
        let newCells = media.map({ MediaItem(title: $0.Title, plot: nil, year: $0.Year, id: $0.imdbID, poster: $0.Poster) })
        if page == 1 {
            cells = newCells
        } else {
            cells.append(contentsOf: newCells)
        }
        snapshot = createCollectionViewsSnapshot(cells: cells)
        updateCollectionView()
    }
 
    func updateResults(searchText: String) {
        let spinner = view.startSpinner(nil)
        networkHandler.getAllMedia(withTitle: searchText, fromYear: nil, fromPage: page) {
            [weak self] result, error in
            guard let self = self else { return }
            guard let apiResult = result, error == nil else {
                DispatchQueue.main.sync {
                    MovieApiAlertVC.showAlertHelper(title: "Error", message: error!.rawValue, confirmationButtonText: "Ok", cancelButtonText: nil, viewController: self)
                    spinner.stopAnimating()
                }
                return
            }
            DispatchQueue.main.sync {
                self.title = "Results"
                self.showMedia(media: apiResult.Search)
                spinner.stopAnimating()
            }
        }
    }
    
    @objc func removeResultsFromPage() {
        guard !cells.isEmpty else { return }
        let alert = UIAlertController(title: "Warning", message: "Do you want to erase the results from the screen?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) {
            [weak self] _ in
            guard let self = self else { return }
            self.cells.removeAll(keepingCapacity: true)
            
            //if let media = dataSource.itemIdentifier(for: IndexPath) {} -> gives me the MediaItem on this indexPath
            self.snapshot.deleteAllItems()
            self.updateCollectionView()
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
     }
}


extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMedia = cells[indexPath.item]
        let spinner = collectionView.cellForItem(at: indexPath)!.startSpinner(nil)
        self.networkHandler.getMedia(id: selectedMedia.id) {
            // must do a api call because there is no plot available after the initial api call for the searchVC(API Parameter 's' gives no plots back)
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
                let mediaItem = MediaItem(title: apiResult.Title, plot: apiResult.Plot, year: apiResult.Year, id: apiResult.imdbID, poster: apiResult.Poster)
                let vc = DetailViewController(media: mediaItem, nibName: nil, bundle: nil)
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
                spinner.stopAnimating()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let viewHeight = view.frame.size.height
        let scrollViewHeight = scrollView.contentSize.height
        if offset + viewHeight > scrollViewHeight + 70, let keyword = searchKeyword {
            page += 1
            updateResults(searchText: keyword)
        }
    }
    
}

extension SearchViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty)! else { return }
        self.updateResults(searchText: searchBar.text!)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty)! else { return }
        self.page = 1
        self.searchKeyword = searchBar.text!
        self.updateResults(searchText: self.searchKeyword)
        dismiss(animated: true)
    }
}







