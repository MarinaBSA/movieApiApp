//
//  MovieApiAlertVC.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 17.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class MovieApiAlertVC: UIViewController {
    let alertTitle: String
    let alertMessage: String
    let alertConfirmationButtonText: String
    let alertCancelButtonText: String?
    let delegate: AlertButtonProcol!
    
    let alertTitleLabel = UILabel()
    let alertMessageLabel = UILabel()
    let alertConfirmationButton = UIButton()
        
    init(withTitle title: String, withMessage message: String, withConfirmationButtonText confirmationButtonText: String, withCancelButtonText CancelButtonText: String?, withDelegate delegate: AlertButtonProcol ) {
        self.alertTitle = title
        self.alertMessage = message
        self.alertConfirmationButtonText = confirmationButtonText
        self.alertCancelButtonText = CancelButtonText
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setupAlert()
        layoutAlert()
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupAlert() {
        setupTitleLabel()
        setupMessageLabel()
        setupConfirmationButton()
    }
    
    private func layoutAlert() {
        layoutView()
        layoutTitleLabel()
        layoutMessageLabel()
        layoutConfirmationButton()
    }
    
    private func layoutView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.label.cgColor
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 225),
            view.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    private func setupTitleLabel() {
        view.addSubview(alertTitleLabel)
        alertTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertTitleLabel.text = alertTitle
        alertTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        alertTitleLabel.textAlignment = .center
    }
    
    private func setupMessageLabel() {
        view.addSubview(alertMessageLabel)
        alertMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        alertMessageLabel.text = alertMessage
        alertMessageLabel.numberOfLines = 0
        let computedFont = UIDevice.current.name == "iPhone SE" ? UIFont.preferredFont(forTextStyle: .caption1) : UIFont.preferredFont(forTextStyle: .body)
        alertMessageLabel.font = computedFont
        alertMessageLabel.textAlignment = .center
    }
    
    private func setupConfirmationButton() {
        view.addSubview(alertConfirmationButton)
        alertConfirmationButton.translatesAutoresizingMaskIntoConstraints = false
        alertConfirmationButton.setTitle(alertConfirmationButtonText, for: .normal)
        alertConfirmationButton.setTitleColor(.label, for: .normal)
        alertConfirmationButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        alertConfirmationButton.titleLabel?.textAlignment = .center
        alertConfirmationButton.layer.borderColor = UIColor.label.cgColor
        alertConfirmationButton.layer.borderWidth = 1.5
        alertConfirmationButton.layer.cornerRadius = 10
        alertConfirmationButton.backgroundColor = .secondarySystemFill
        alertConfirmationButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }
    
  
    private func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            alertTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            alertTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            alertTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutMessageLabel() {
        NSLayoutConstraint.activate([
            alertMessageLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 20),
            alertMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            alertMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutConfirmationButton() {
        NSLayoutConstraint.activate([
            alertConfirmationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alertConfirmationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alertConfirmationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            alertConfirmationButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            alertConfirmationButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func dismissAlert() {
        delegate.confirmAction()
    }
    
}
