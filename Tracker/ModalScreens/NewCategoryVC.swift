//
//  NewCategoryVC.swift
//  Tracker
//
//  Created by Sergey Telnov on 22/11/2024.
//

import Foundation
import UIKit

protocol NewCategoryDelegateProtocol: AnyObject {
    func didReceiveNewCategory(categoryTitle: String)
}

final class NewCategoryVC: UIViewController {
    
    var delegate: NewCategoryDelegateProtocol?
    var titleSelection: String = ""
    
    var newCategoryTitle: UITextField!
    var newCategoryDoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewCategoryVC()
    }
    
    @objc private func newCategoryDoneButtonPressed() {
            delegate?.didReceiveNewCategory(categoryTitle: titleSelection)
            navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            titleSelection = text
            updateButtonState()
        }
    }
    
    private func updateButtonState() {
        if titleSelection != "" {
            enableDoneButton()
        } else {
            disableDoneButton()
        }
    }
    
    private func enableDoneButton() {
        newCategoryDoneButton.isEnabled = true
        newCategoryDoneButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
    }
    
    private func disableDoneButton() {
        newCategoryDoneButton.isEnabled = false
        newCategoryDoneButton.backgroundColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
    }
    
    private func setupNewCategoryVC() {
        view.backgroundColor = .white
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true
        
        newCategoryTitle = UITextField()
        newCategoryTitle.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTitle.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        newCategoryTitle.layer.cornerRadius = 16
        newCategoryTitle.placeholder = "Введите название трекера"
        newCategoryTitle.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        newCategoryTitle.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(newCategoryTitle)
        
        newCategoryDoneButton = UIButton(type: .system)
        newCategoryDoneButton.setTitle("Готово", for: .normal)
        newCategoryDoneButton.layer.cornerRadius = 16
        newCategoryDoneButton.isEnabled = false
        newCategoryDoneButton.backgroundColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
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
