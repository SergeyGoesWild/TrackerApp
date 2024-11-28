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
    var warningLabel: UILabel!
    
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
            if text.count > 38 {
                showWarning()
                let start = text.startIndex
                let end = text.index(start, offsetBy: 38)
                let slice = text[start..<end]
                newCategoryTitle.text = String(slice)
            } else {
                hideWarning()
                titleSelection = text
                updateButtonState()
            }
        }
    }
    
    @objc private func clearTextField() {
        newCategoryTitle.text = ""
    }
    
    private func showWarning() {
        warningLabel.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideWarning() {
        warningLabel.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
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
        let clearButton = UIButton(type: .system)
        clearButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        newCategoryTitle.rightView = clearButton
        newCategoryTitle.clearButtonMode = .whileEditing
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: newCategoryTitle.frame.height))
        newCategoryTitle.leftView = leftPaddingView
        newCategoryTitle.leftViewMode = .always
        view.addSubview(newCategoryTitle)
        
        warningLabel = UILabel()
        warningLabel.text = "Ограничение 38 символов"
        warningLabel.font = .systemFont(ofSize: 17)
        warningLabel.textAlignment = .center
        warningLabel.isHidden = true
        warningLabel.textColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warningLabel)
        
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
            
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            warningLabel.topAnchor.constraint(equalTo: newCategoryTitle.bottomAnchor, constant: 8),
            
            newCategoryDoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newCategoryDoneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newCategoryDoneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            newCategoryDoneButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
