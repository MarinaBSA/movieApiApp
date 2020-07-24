//
//  ToastView.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 23.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class ToastView: UIView {
    let messageLabel = UILabel()
    weak var parentView: UIView?
    
    init(text: String, parentView: UIView, frame: CGRect) {
        self.parentView = parentView
        super.init(frame: frame)
        self.messageLabel.text = text
        configure()
    }
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }

    
    private func configure() {
        parentView!.addSubview(self)
        setupView()
        setupTimer()
    }
    
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.borderWidth = 2
        layer.cornerRadius = 10
        layer.borderColor = UIColor.label.cgColor
        addSubview(messageLabel)
        setupMessageLabel()
        layoutView()
    }
    
    private func setupMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    private func layoutView() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50),
            self.widthAnchor.constraint(equalToConstant: parentView!.frame.width * 0.5),
            self.centerXAnchor.constraint(equalTo: parentView!.centerXAnchor),
            self.bottomAnchor.constraint(equalTo: parentView!.bottomAnchor, constant: -20)
        ])
        
        layoutMessageLabel()
    }
    
    private func layoutMessageLabel() {
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
        ])
    }
    
    private func setupTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            [weak self] in
            self?.removeFromSuperview()
        })
    }
    
}
