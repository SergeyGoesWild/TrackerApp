//
//  NewTrackerSpecs.swift
//  Tracker
//
//  Created by Sergey Telnov on 18/11/2024.
//

import Foundation
import UIKit

final class NewTrackerSpecsVC: UIViewController {
    var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerSpecsView()
    }
    
    private func setupTrackerSpecsView() {
        view.backgroundColor = .white
        navigationItem.title = "Новая привычка"
        
        textLabel = UILabel()
        textLabel.text = "Second modal screen"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
