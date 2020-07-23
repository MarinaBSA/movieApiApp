//
//  DetailViewController.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 15.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let media: MediaItem
    
    var imageView = UIImageView()
    let titleLabel = UILabel()
    let yearLabel = UILabel()
    let plotLabel = UITextView()
    let closeButton = UIButton(type: .close)
    let favouriteButton = UIButton(type: .custom)
    
    
    init(media: MediaItem, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.media = media
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissDetailVC), for: .touchUpInside)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.addTarget(self, action: #selector(addToFavourite), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(yearLabel)
        view.addSubview(plotLabel)
        view.addSubview(closeButton)
        view.addSubview(favouriteButton)
      
        configureImageView()
        configureMediaTitle()
        configureYearLabel()
        configurePlotLabel()
        configureCloseButton()
        configureFavouriteButton()
        
        layoutCloseButton()
        layoutImageView()
        layoutTitleLabel()
        layoutYearLabel()
        layoutPlotLabel()
        layoutFavouriteButton()
        
    }
    
    private func configureYearLabel() {
        if let year = media.year {
            yearLabel.text = year
            yearLabel.font = UIFont.preferredFont(forTextStyle: .title2)
            yearLabel.textColor = .label
        }
    }
    
    private func configurePlotLabel() {
      if let plot = media.plot {
            plotLabel.text = plot
            plotLabel.isEditable = false
            plotLabel.adjustsFontForContentSizeCategory = true
            plotLabel.isScrollEnabled = true
            plotLabel.showsVerticalScrollIndicator = true
            plotLabel.font = UIFont.preferredFont(forTextStyle: .title3)
            plotLabel.textColor = .label
            
        }
    }
    
    private func configureImageView() {
        if let _ = URL(string: media.poster!) {
            setImage()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = .secondarySystemBackground
            
            let alphaLayer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.5))
            alphaLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
            imageView.addSubview(alphaLayer)
            view.addSubview(imageView)
        }
    }
    
    private func configureMediaTitle() {
        titleLabel.text = media.title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .label
    }
    
    private func configureCloseButton() {
        closeButton.titleLabel?.text = "Results"
    }
    
    private func configureFavouriteButton() {
        let favImage = UIImage(systemName: SFSymbols.favouriteMedia.rawValue)
        favouriteButton.setImage(favImage, for: .normal)
        
        if let isFav = FavoritesManager.isFavorite(media: media) {
            favouriteButton.tintColor = isFav ? .systemYellow : .systemGray
            return
        }
        favouriteButton.tintColor = .systemGray
    }
    
    private func layoutCloseButton() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ])
    }
    
    private func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutYearLabel() {
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yearLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            yearLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutPlotLabel() {
        NSLayoutConstraint.activate([
            plotLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 20),
            plotLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            plotLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            plotLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func layoutFavouriteButton() {
        NSLayoutConstraint.activate([
            favouriteButton.firstBaselineAnchor.constraint(equalTo: closeButton.firstBaselineAnchor),
            favouriteButton.lastBaselineAnchor.constraint(equalTo: closeButton.lastBaselineAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favouriteButton.heightAnchor.constraint(equalToConstant: closeButton.frame.height),
            favouriteButton.widthAnchor.constraint(equalToConstant: closeButton.frame.width),
        ])
    }
    
    private func setImage() {
        if let passedURL = media.poster {
            if let cachedImage = SearchViewController.imageCache.object(forKey: NSString(string: passedURL)) {
                // image already cached -- get it from the cache
                imageView.image = cachedImage
                return
            }
            // image not cached -- cache it
            NetworkManager.getImage(mediaURL: passedURL) {
                [weak self]
                image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
        imageView.image = UIImage(systemName: Images.placeholder.rawValue)
        imageView.tintColor = .label
    }
    
    @objc private func dismissDetailVC() {
        dismiss(animated: true) 
    }
    
    @objc private func addToFavourite() {
        FavoritesManager.setFavorite(media: media) {
            [weak self] error in
            guard let self = self else { return }
            if let passedError = error {
                MovieApiAlertViewController.showAlertHelper(title: "Error", message: passedError.rawValue, confirmationButtonText: "Ok", cancelButtonText: nil, viewController: self)
                return
            }
            self.view.addSubview(ToastView(text: Messages.savedAsFavorit.rawValue, parentView: self.view, frame: .zero))
            self.favouriteButton.tintColor = .systemYellow
        }
    }
}
