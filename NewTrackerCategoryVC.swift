//
//  NewTrackerCategoryViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 18/11/2024.
//

import Foundation
import UIKit

final class NewTrackerCategoryVC: UIViewController {
    var textLabel: UILabel!
    var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerSpecsView()
    }
    
    @objc private func dismissButtonPressed() {
        let specsVC = NewTrackerSpecsVC()
        navigationController?.pushViewController(specsVC, animated: true)
//            guard let presentingVC = self.presentingViewController else { return }
//            dismiss(animated: true) {
//            let specsVC = NewTrackerSpecsVC()
//            let navController = UINavigationController(rootViewController: specsVC)
//            presentingVC.present(navController, animated: true)
//        }
    }
    
    private func setupTrackerSpecsView() {
        view.backgroundColor = .white
        navigationItem.title = "Создание трекера"
        
        textLabel = UILabel()
        textLabel.text = "First modal screen"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dismissButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            dismissButton.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor),
        ])
    }
}
