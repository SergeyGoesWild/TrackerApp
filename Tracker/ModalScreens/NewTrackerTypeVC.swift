//
//  NewTrackerCategoryViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 18/11/2024.
//

import Foundation
import UIKit

enum trackerTypes {
    case habit
    case event
}

final class NewTrackerTypeVC: UIViewController {
    var habitButton: UIButton!
    var eventButton: UIButton!
    
    weak var delegateLink: TrackerSpecsDelegate?
    var delegateListShare: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerTypeView()
    }
    
    @objc private func habitButtonPressed() {
        let specsVC = NewTrackerSpecsVC()
        specsVC.newTrackerType = .habit
        specsVC.delegate = delegateLink
        guard let delegateListShare else { return }
        specsVC.possibleCategories.append(contentsOf: delegateListShare)
        navigationController?.pushViewController(specsVC, animated: true)
    }
    
    @objc private func eventButtonPressed() {
        let specsVC = NewTrackerSpecsVC()
        specsVC.newTrackerType = .event
        specsVC.delegate = delegateLink
        guard let delegateListShare else { return }
        specsVC.possibleCategories.append(contentsOf: delegateListShare)
        navigationController?.pushViewController(specsVC, animated: true)
    }
    
    private func setupTrackerTypeView() {
        view.backgroundColor = .white
        navigationItem.title = "Создание трекера"
        
        habitButton = UIButton(type: .system)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.layer.cornerRadius = 16
        habitButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        habitButton.setTitleColor(.white, for: .normal)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        view.addSubview(habitButton)
        
        eventButton = UIButton(type: .system)
        eventButton.setTitle("Нерегулярные событие", for: .normal)
        eventButton.layer.cornerRadius = 16
        eventButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        eventButton.setTitleColor(.white, for: .normal)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.addTarget(self, action: #selector(eventButtonPressed), for: .touchUpInside)
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
