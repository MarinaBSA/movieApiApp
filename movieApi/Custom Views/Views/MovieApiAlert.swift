//
//  MovieApiAlertView.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 17.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class MovieApiAlertView: UIView {
    let alert: UIViewController
    
    init(frame: CGRect, alert: UIViewController) {
        self.alert = alert
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setupView()
    }
    
    private func setupView() {
        let computedColor =  currentInterfaceStyleIsDark() ? UIColor(red: 0.2 , green: 0.2, blue: 0.2, alpha: 0.7) : UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        backgroundColor = computedColor
        addSubview(alert.view)
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alert.view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alert.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }

    private func currentInterfaceStyleIsDark() -> Bool {
        switch traitCollection.userInterfaceStyle {
            case .dark:
                return true
            default:
                return false
        }
    }
}
