//
//  UIView+Ext.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 16.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

extension UIView {
    func startSpinner(_ color: UIColor?) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        if let spinnerColor = color {
            spinner.color = spinnerColor
        }
        self.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.startAnimating()
        return spinner
    }
    
    func showToast(message: String) {
        let toast = ToastView(text: message, parentView: self, frame: self.frame)
        self.addSubview(toast)
    }
     
}
