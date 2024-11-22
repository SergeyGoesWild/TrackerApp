//
//  CategoryList.swift
//  Tracker
//
//  Created by Sergey Telnov on 22/11/2024.
//

import Foundation
import UIKit

final class CategoryListVC: UIViewController {
    
    let categoriez = ["Важное", "Норм", "Так себе"]
    var selectedIndexPath: IndexPath?
    
    var categoryTableView: UITableView!
    var addCategoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryListVC()
    }
    
    @objc private func addCategoryButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupCategoryListVC() {
        view.backgroundColor = .white
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true
        
        categoryTableView = UITableView(frame: .zero, style: .plain)
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        categoryTableView.layer.cornerRadius = 16
        categoryTableView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        categoryTableView.tableFooterView = UIView(frame: .zero)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        view.addSubview(categoryTableView)
        
        addCategoryButton = UIButton(type: .system)
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        addCategoryButton.setTitleColor(.white, for: .normal)
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTableView.heightAnchor.constraint(equalToConstant: 525),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

extension CategoryListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndexPath {
            let previousCell = tableView.cellForRow(at: selectedIndex)
            previousCell?.accessoryType = .none
        }
        
        selectedIndexPath = indexPath
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriez.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: Здесь тоже удалить лишние сепараторы
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoriez[indexPath.row]
        cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

