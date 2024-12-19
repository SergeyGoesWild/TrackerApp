//
//  StatViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 05/11/2024.
//

import Foundation
import UIKit

final class StatVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Statistics here!"
        label.font =
            .systemFont(ofSize: 20)
        label.sizeToFit()
        label.textAlignment = .center
        view.addSubview(label)
        NSLayoutConstraint.activate([
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
