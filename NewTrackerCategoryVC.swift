//
//  NewTrackerCategoryViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 18/11/2024.
//

import Foundation
import UIKit

final class NewTrackerCategoryVC: UIViewController {
    var habitButton: UIButton!
    var eventButton: UIButton!
    
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
        
        habitButton = UIButton(type: .system)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.layer.cornerRadius = 16
        habitButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        habitButton.setTitleColor(.white, for: .normal)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        view.addSubview(habitButton)
        
        eventButton = UIButton(type: .system)
        eventButton.setTitle("Нерегулярные событие", for: .normal)
        eventButton.layer.cornerRadius = 16
        eventButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        eventButton.setTitleColor(.white, for: .normal)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        view.addSubview(eventButton)
        
        NSLayoutConstraint.activate([
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 8),
        ])
    }
}
