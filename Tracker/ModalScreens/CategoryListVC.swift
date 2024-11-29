//
//  CategoryList.swift
//  Tracker
//
//  Created by Sergey Telnov on 22/11/2024.
//

import Foundation
import UIKit
    
protocol CategoryDelegateProtocol: AnyObject {
    func didReceiveChosenCategory(categoryTitle: String)
    func didAppendNewCategory(categoryTitle: String)
}

final class CategoryListVC: UIViewController {
    
    weak var delegate: CategoryDelegateProtocol?
    var categoryList: [String] = []
    var categorySelection: String?
    
    var categoryTableView: UITableView!
    var addCategoryButton: UIButton!
    var emptyListImage: UIImageView!
    var emptyListLabel: UILabel!
    
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryListVC()
    }
    
    @objc private func addCategoryButtonPressed() {
        let nextScreen = NewCategoryVC()
        nextScreen.delegate = self
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    private func setupEmptyCategoryScreen() {
        emptyListImage = UIImageView()
        emptyListImage.image = UIImage(named: "StarIcon")
        emptyListImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyListImage)
        
        emptyListLabel = UILabel()
        emptyListLabel.text = "Привычки и события можно\nобъединить по смыслу"
        emptyListLabel.font = .systemFont(ofSize: 12)
        //TODO: настроить межстрочный интервал
        emptyListLabel.numberOfLines = 0
        emptyListLabel.textAlignment = .center
        emptyListLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyListLabel)
        
        NSLayoutConstraint.activate([
            emptyListImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyListImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -386),
            
            emptyListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyListLabel.topAnchor.constraint(equalTo: emptyListImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupNoNEmptyCategoryScreen() {
        emptyListImage?.removeFromSuperview()
        emptyListLabel?.removeFromSuperview()
        emptyListImage = nil
        emptyListLabel = nil
        
        categoryTableView = UITableView(frame: .zero, style: .plain)
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        categoryTableView.layer.cornerRadius = 16
        categoryTableView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        categoryTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        view.addSubview(categoryTableView)
        
        tableViewHeightConstraint = categoryTableView.heightAnchor.constraint(equalToConstant: CGFloat(75*categoryList.count))
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
        ])
    }
    
    private func setupCategoryListVC() {
        view.backgroundColor = .white
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true
        
        if categoryList.isEmpty {
            setupEmptyCategoryScreen()
        } else {
            setupNoNEmptyCategoryScreen()
        }
        
        addCategoryButton = UIButton(type: .system)
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        addCategoryButton.setTitleColor(.white, for: .normal)
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
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
        if let categorySelection {
            let previousCellIndex = categoryList.firstIndex(where: {$0 == categorySelection} )
            let previousCell = tableView.cellForRow(at: IndexPath(row: previousCellIndex!, section: 0))
            previousCell?.accessoryType = .none
        }
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        
        guard let stringForDelegate = selectedCell?.textLabel?.text else { return }
        delegate?.didReceiveChosenCategory(categoryTitle: stringForDelegate)
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CategoryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = categoryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row]
        cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        if currentItem == categorySelection {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension CategoryListVC: NewCategoryDelegateProtocol {
    func didReceiveNewCategory(categoryTitle: String) {
        if !categoryList.contains(categoryTitle) {
            categoryList.append(categoryTitle)
            if categoryList.count == 1 {
                setupNoNEmptyCategoryScreen()
            }
            categoryTableView.reloadData()
            tableViewHeightConstraint.constant = CGFloat(75*categoryList.count)
            delegate?.didAppendNewCategory(categoryTitle: categoryTitle)
        }
    }
}
