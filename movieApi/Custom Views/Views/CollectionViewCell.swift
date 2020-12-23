//
//  CollectionViewCell.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//
//BUGS:
// Search for "fff" then search for "paris" -> no more items

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID = "Cell"
    
    var media: MediaItem?
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    var year: String? {
        didSet {
            yearLabel.text = year
        }
    }
    var spinner: UIActivityIndicatorView!
    
    let titleLabel = UILabel()
    let yearLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        
        configureTitleLabel()
        configureYearLabel()
        configureImageView()
        configureContentView()
        
        layoutTitleLabel()
        layoutYearLabel()
        layoutImageView()
    }
    func setLabels(media: MediaItem) {
        self.media = media
        
        // Set as favorite
        if let isFav = FavoritesManager.isFavorite(media: media), let _ = self.media {
            titleLabel.textColor = isFav ? .systemYellow : .label
            yearLabel.textColor = isFav ? .systemYellow : .label
        }
        guard spinner != nil else { fatalError("No Spinner") }
        if let passedURL = media.poster {
            // TODO Use NetworkManager.getImage and pass this to the completion handler
            if let cachedImage = SearchViewController.imageCache.object(forKey: NSString(string: passedURL)) {
                // image already cached
                imageView.image = cachedImage
                spinner.stopAnimating()
                self.title = media.title
                self.year = media.year ?? "Unknown"
                return
            }
            // image not cached -- cache it
            NetworkManager.getImage(media: media) {
                [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.sync {
                    self.imageView.image = image
                    //self.imageView.image = UIImage(systemName: "pencil")
                    self.imageView.tintColor = .label
                    self.spinner.stopAnimating()
                    self.title = media.title
                    self.year = media.year ?? "Unknown"
                }
            }
        }
    }
    
    private func getImage(fromURL url: String, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            if let imageURL = URL(string: url) {
                do {
                    let data = try Data(contentsOf: imageURL)
                    if let compressedImageData = UIImage(data: data)?.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: compressedImageData) {
                        SearchViewController.imageCache.setObject(compressedImage, forKey: NSString(string: url))
                        completion(compressedImage)
                    }
                } catch {
                    print("Cannot get image from url. Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func configureYearLabel() {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.textColor = .label
        yearLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        yearLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    private func configureContentView() {
        contentView.layer.insertSublayer(getGradientLayer(), at: 0)
        contentView.layer.borderWidth = 0.25
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    private func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutYearLabel() {
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }
    
    private func getGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.frame
        gradientLayer.colors = [UIColor.systemBackground.cgColor, UIColor.systemGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: gradientLayer.frame.width/2, y: 0)
        gradientLayer.endPoint = CGPoint(x: gradientLayer.frame.width/2, y: 1)
        return gradientLayer
    }
}
