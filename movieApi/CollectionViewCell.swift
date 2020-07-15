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

    //let poster = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabels(title: String, year: String?) {
         self.title = title
         self.year = year ?? "Unknown"
    }
    
    private func configure() {
        backgroundColor = .tertiarySystemBackground
        addSubview(titleLabel)
        addSubview(yearLabel)
        
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
                
        titleLabel.textColor = .label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        yearLabel.textColor = .label
        yearLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        contentView.layer.borderWidth = 5
        contentView.layer.cornerRadius = 20
        
        #warning("make this code great again -- repetitive padding (10/-10)")
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    

}
