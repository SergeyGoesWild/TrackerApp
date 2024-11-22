//
//  NewCategoryVC.swift
//  Tracker
//
//  Created by Sergey Telnov on 22/11/2024.
//

import Foundation
import UIKit

final class NewCategoryVC: UIViewController {
    
    var newCategoryTitle: UITextField!
    var newCategoryDoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewCategoryVC()
    }
    
    @objc private func newCategoryDoneButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func NewCategoryVC() {
        view.backgroundColor = .white
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true
        
        newCategoryTitle = UITextField()
        newCategoryTitle.placeholder = "Введите название категории"
        newCategoryTitle.layer.cornerRadius = 16
        newCategoryTitle.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        newCategoryTitle.textColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        newCategoryTitle.textAlignment = .left
        newCategoryTitle.font = .systemFont(ofSize: 17)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: newCategoryTitle.frame.height))
        newCategoryTitle.leftView = paddingView
        newCategoryTitle.leftViewMode = .always
        newCategoryTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newCategoryTitle)
        
        newCategoryDoneButton = UIButton(type: .system)
        newCategoryDoneButton.setTitle("Готово", for: .normal)
        newCategoryDoneButton.layer.cornerRadius = 16
        newCategoryDoneButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        newCategoryDoneButton.setTitleColor(.white, for: .normal)
        newCategoryDoneButton.translatesAutoresizingMaskIntoConstraints = false
        newCategoryDoneButton.addTarget(self, action: #selector(newCategoryDoneButtonPressed), for: .touchUpInside)
        view.addSubview(newCategoryDoneButton)
        
        NSLayoutConstraint.activate([
            newCategoryTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newCategoryTitle.heightAnchor.constraint(equalToConstant: 75),
            
            newCategoryDoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newCategoryDoneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newCategoryDoneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            newCategoryDoneButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
