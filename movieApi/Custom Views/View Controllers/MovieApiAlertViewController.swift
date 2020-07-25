//
//  MovieApiAlertVC.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 17.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class MovieApiAlertViewController: UIViewController {
    let alertTitle: String
    let alertMessage: String
    let alertConfirmationButtonText: String
    let alertCancelButtonText: String?
    
    let alertView = UIView()
    let alertTitleLabel = UILabel()
    let alertMessageLabel = UILabel()
    let alertConfirmationButton = UIButton()
        
    init(withTitle title: String, withMessage message: String, withConfirmationButtonText confirmationButtonText: String, withCancelButtonText CancelButtonText: String?) {
        self.alertTitle = title
        self.alertMessage = message
        self.alertConfirmationButtonText = confirmationButtonText
        self.alertCancelButtonText = CancelButtonText
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let computedColor =  currentInterfaceStyleIsDark() ? UIColor(red: 0.2 , green: 0.2, blue: 0.2, alpha: 0.7) : UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.backgroundColor = computedColor
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        setupAlert()
        layoutAlert()
    }
    
    private func setupAlert() {
        setupAlertView()
        setupTitleLabel()
        setupMessageLabel()
        setupConfirmationButton()
    }
    
    private func layoutAlert() {
        layoutAlertView()
        layoutTitleLabel()
        layoutMessageLabel()
        layoutConfirmationButton()
    }
    
    private func setupAlertView() {
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = .systemBackground
        alertView.layer.borderWidth = 1.5
        alertView.layer.cornerRadius = 10
        alertView.layer.borderColor = UIColor.label.cgColor
        
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
    
    private func layoutAlertView() {
        NSLayoutConstraint.activate([
            alertView.heightAnchor.constraint(equalToConstant: 225),
            alertView.widthAnchor.constraint(equalToConstant: 250),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
  
    private func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            alertTitleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            alertTitleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            alertTitleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutMessageLabel() {
        NSLayoutConstraint.activate([
            alertMessageLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 20),
            alertMessageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            alertMessageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutConfirmationButton() {
        NSLayoutConstraint.activate([
            alertConfirmationButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            alertConfirmationButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            alertConfirmationButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            alertConfirmationButton.widthAnchor.constraint(equalTo: alertView.widthAnchor),
            alertConfirmationButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true)
    }

    private func currentInterfaceStyleIsDark() -> Bool {
        switch traitCollection.userInterfaceStyle {
            case .dark:
                return true
            default:
                return false
        }
    }
    
    static func showAlertHelper(title: String, message: String, confirmationButtonText: String, cancelButtonText: String?, viewController: UIViewController) {
        let alertVC = MovieApiAlertViewController(withTitle: title, withMessage: message, withConfirmationButtonText: confirmationButtonText, withCancelButtonText: cancelButtonText)
        viewController.present(alertVC, animated: true)
    }
}
