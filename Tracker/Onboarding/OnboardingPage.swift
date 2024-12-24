//
//  OnboardingPage.swift
//  Tracker
//
//  Created by Sergey Telnov on 23/12/2024.
//

import Foundation
import UIKit

final class OnboardingPage: UIViewController {
    private var backgroundImageView: UIImageView!
    private var textLabel: UILabel!
    private var closeButton: UIButton!
    
    private var textTitle: String
    private var image: UIImage
    
    init(textTitle: String, image: UIImage) {
        self.textTitle = textTitle
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboardingPage01()
    }
    
    private func setupOnboardingPage01() {
        backgroundImageView = UIImageView(image: image)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        textLabel = UILabel()
        textLabel.text = textTitle
        textLabel.font = .systemFont(ofSize: 32, weight: .bold)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        closeButton = UIButton(type: .system)
        closeButton.setTitle("Вот это технологии!", for: .normal)
        closeButton.layer.cornerRadius = 16
        closeButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.heightAnchor.constraint(equalToConstant: 80),
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 60),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }
    
    @objc private func closeButtonPressed() {
        let nextViewController = RootViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first {
            keyWindow.rootViewController = nextViewController
            UIView.transition(with: keyWindow,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
        
    }
}
