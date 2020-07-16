//
//  CollectionViewCell.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 14.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID = "Cell"
    
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
    
    func setLabels(title: String, year: String?, imageURL: String?) {
        if let passedURL = imageURL {
            if let cachedImage = SearchController.imageCache.object(forKey: NSString(string: passedURL)) {
                // image already cached
                imageView.image = cachedImage
                return
            }
            // image not cached -- cache it
            if let imageURL = URL(string: passedURL) {
                do {
                    let data = try Data(contentsOf: imageURL)
                    if let compressedImageData = UIImage(data: data)?.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: compressedImageData) {
                        SearchController.imageCache.setObject(compressedImage, forKey: NSString(string: passedURL))
                        imageView.image = UIImage(data: compressedImageData)
                    }
                } catch {
                    print("Cannot get image from url. Error: \(error.localizedDescription)")
                    imageView.image = UIImage(systemName: "bandage")
                    imageView.tintColor = .brown
                }
            }
        }
        #warning("in case there is no image(test: covid) -- show placeholder image ")
        
        self.title = title
        self.year = year ?? "Unknown"
    }
    
    private func configure() {
        backgroundColor = .secondarySystemBackground
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(yearLabel)
        
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.textColor = .label
        yearLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        yearLabel.adjustsFontForContentSizeCategory = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        contentView.layer.addSublayer(setupGradientLayer())
        contentView.layer.borderWidth = 0.25
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        #warning("make this code great again -- repetitive padding (10/-10)")
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                      
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
        
    }
    
    private func setupGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.frame
        gradientLayer.colors = [UIColor.systemBackground.cgColor, UIColor.systemGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: gradientLayer.frame.width/2, y: 0)
        gradientLayer.endPoint = CGPoint(x: gradientLayer.frame.width/2, y: 1)
        return gradientLayer
    }
    

}