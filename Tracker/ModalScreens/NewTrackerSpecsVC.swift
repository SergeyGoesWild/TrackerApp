//
//  NewTrackerSpecs.swift
//  Tracker
//
//  Created by Sergey Telnov on 18/11/2024.
//

import Foundation
import UIKit

final class NewTrackerSpecsVC: UIViewController {
    
    let specsList = ["Категория", "Расписание"]
    let emojiList = ["🙂", "😻", "🌺", "🐶", "❤", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪",]
    let colorList = [UIColor(red: 0.99, green: 0.30, blue: 0.29, alpha: 1.00),
                     UIColor(red: 1.00, green: 0.53, blue: 0.12, alpha: 1.00),
                     UIColor(red: 0.00, green: 0.48, blue: 0.98, alpha: 1.00),
                     UIColor(red: 0.43, green: 0.27, blue: 1.00, alpha: 1.00),
                     UIColor(red: 0.20, green: 0.81, blue: 0.41, alpha: 1.00),
                     UIColor(red: 0.90, green: 0.43, blue: 0.83, alpha: 1.00),
                     UIColor(red: 0.98, green: 0.83, blue: 0.83, alpha: 1.00),
                     UIColor(red: 0.20, green: 0.65, blue: 1.00, alpha: 1.00),
                     UIColor(red: 0.27, green: 0.90, blue: 0.62, alpha: 1.00),
                     UIColor(red: 0.21, green: 0.20, blue: 0.49, alpha: 1.00),
                     UIColor(red: 1.00, green: 0.40, blue: 0.30, alpha: 1.00),
                     UIColor(red: 1.00, green: 0.60, blue: 0.80, alpha: 1.00),
                     UIColor(red: 0.96, green: 0.77, blue: 0.55, alpha: 1.00),
                     UIColor(red: 0.47, green: 0.58, blue: 0.96, alpha: 1.00),
                     UIColor(red: 0.51, green: 0.17, blue: 0.95, alpha: 1.00),
                     UIColor(red: 0.68, green: 0.34, blue: 0.85, alpha: 1.00),
                     UIColor(red: 0.55, green: 0.45, blue: 0.90, alpha: 1.00),
                     UIColor(red: 0.18, green: 0.82, blue: 0.35, alpha: 1.00)]
    
    var specsScrollView: UIScrollView!
    var specsContainer: UIView!
    var titleTextField: UITextField!
    var specsTable: UITableView!
    var emojiCollection: UICollectionView!
    var colorCollection: UICollectionView!
    var createButton: UIButton!
    var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerSpecsView()
    }
    
    @objc private func createButtonPressed() {
        let specsVC = NewTrackerSpecsVC()
        navigationController?.pushViewController(specsVC, animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTrackerSpecsView() {
        view.backgroundColor = .white
        navigationItem.title = "Новая привычка"
        navigationItem.hidesBackButton = true
        
        specsScrollView = UIScrollView()
        specsScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(specsScrollView)
        
        specsContainer = UIView()
        specsContainer.translatesAutoresizingMaskIntoConstraints = false
        specsScrollView.addSubview(specsContainer)
        
        titleTextField = UITextField()
        titleTextField.placeholder = "Введите название трекера"
        titleTextField.layer.cornerRadius = 16
        titleTextField.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        titleTextField.textColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        titleTextField.textAlignment = .left
        titleTextField.font = .systemFont(ofSize: 17)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: titleTextField.frame.height))
        titleTextField.leftView = paddingView
        titleTextField.leftViewMode = .always
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        specsScrollView.addSubview(titleTextField)
        
        specsTable = UITableView(frame: .zero, style: .plain)
        specsTable.dataSource = self
        specsTable.delegate = self
        specsTable.register(UITableViewCell.self, forCellReuseIdentifier: "specsCell")
        specsTable.translatesAutoresizingMaskIntoConstraints = false
        specsTable.layer.cornerRadius = 16
        specsTable.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        specsTable.tableFooterView = UIView(frame: .zero)
        //TODO: поправить линии сепараторы
        specsScrollView.addSubview(specsTable)
        
        emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollection.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiCollection.register(EmojiHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "emojiHeader")
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        emojiCollection.delegate = self
        emojiCollection.dataSource = self
        emojiCollection.tag = 1
        specsScrollView.addSubview(emojiCollection)
        
        colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorCollection.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        colorCollection.register(EmojiHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "emojiHeader")
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        colorCollection.delegate = self
        colorCollection.dataSource = self
        colorCollection.tag = 2
        specsScrollView.addSubview(colorCollection)
        
        createButton = UIButton(type: .system)
        createButton.setTitle("Создать", for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        createButton.setTitleColor(.white, for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        specsScrollView.addSubview(createButton)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00).cgColor
        cancelButton.setTitleColor(UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00), for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        specsScrollView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            specsScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            specsScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            specsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            specsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            specsContainer.topAnchor.constraint(equalTo: specsScrollView.topAnchor),
            specsContainer.leadingAnchor.constraint(equalTo: specsScrollView.leadingAnchor),
            specsContainer.trailingAnchor.constraint(equalTo: specsScrollView.trailingAnchor),
            specsContainer.bottomAnchor.constraint(equalTo: specsScrollView.bottomAnchor),
            specsContainer.widthAnchor.constraint(equalTo: specsScrollView.widthAnchor),
            specsContainer.heightAnchor.constraint(greaterThanOrEqualTo: specsScrollView.heightAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: specsContainer.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            specsTable.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 16),
            specsTable.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -16),
            specsTable.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            specsTable.heightAnchor.constraint(equalToConstant: 150),
            
            emojiCollection.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 18),
            emojiCollection.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -18),
            emojiCollection.topAnchor.constraint(equalTo: specsTable.bottomAnchor, constant: 32),
            //TODO: внизу какой-то странный отступ, нужно поправить
            emojiCollection.heightAnchor.constraint(equalToConstant: 204),
            
            colorCollection.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 18),
            colorCollection.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -18),
            colorCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 16),
            //TODO: внизу какой-то странный отступ, нужно поправить
            colorCollection.heightAnchor.constraint(equalToConstant: 204),
            
            createButton.leadingAnchor.constraint(equalTo: specsContainer.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: specsContainer.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor),
        ])
    }
}

extension NewTrackerSpecsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //TODO: Настроить сохранение текста из формы
        //        trackerTitle = textField.text
        //        print("Input saved: \(trackerTitle ?? "No input")")
    }
}

extension NewTrackerSpecsVC: UICollectionViewDelegate {
    
}

extension NewTrackerSpecsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.tag == 1 ? emojiList.count : colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell
            cell?.emojiCellLabel.text = emojiList[indexPath.row]
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell
            cell?.colorView.backgroundColor = colorList[indexPath.row]
            return cell!
        }
    }
}

extension NewTrackerSpecsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 5 * 5) / CGFloat(6)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension NewTrackerSpecsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalHeight = tableView.bounds.height
        let rowHeight = totalHeight / CGFloat(specsList.count)
        return rowHeight
    }
}

extension NewTrackerSpecsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "specsCell", for: indexPath)
        cell.textLabel?.text = specsList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        return cell
    }
}
