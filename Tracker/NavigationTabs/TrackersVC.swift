//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 05/11/2024.
//

import Foundation
import UIKit

protocol TrackerSpecsDelegate: AnyObject {
    func didReceiveNewTracker(newTrackerCategory: TrackerCategory)
    func didReceiveCategoriesList(newList: [String])
}

final class TrackersVC: UIViewController {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var allPossibleCategories: [String] = []
    
    var starImage: UIImageView!
    var starTextLabel: UILabel!
    var titleLabel: UILabel!
    var plusButton: UIButton!
    var datePicker: UIDatePicker!
    var searchBar: UISearchBar!
    var trackerCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allPossibleCategories = shareAllCategories(categoriesList: categories)
        setupTrackerScreen()
    }
    
    @objc
    private func plusButtonPressed() {
        let modalVC = NewTrackerTypeVC()
        modalVC.delegateLink = self
        modalVC.delegateListShare = allPossibleCategories
        let navController = UINavigationController(rootViewController: modalVC)
        present(navController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    private func setupTrackerScreen() {
        view.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        
        plusButton = UIButton()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setImage(UIImage(named: "PlusIconSVG"), for: .normal)
        plusButton.setTitle("", for: .normal)
        plusButton.tintColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        view.addSubview(plusButton)
        
        datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        view.addSubview(datePicker)
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        let textField = searchBar.searchTextField
        textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 0),
                textField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 0),
                textField.heightAnchor.constraint(equalTo: searchBar.heightAnchor, constant: 0),
                textField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            ])
        view.addSubview(searchBar)
        
        if categories.isEmpty {
            setupNoTrackers()
        } else {
            setupWithTrackers()
        }
        
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    
    private func setupNoTrackers() {
        starImage = UIImageView()
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.image = UIImage(named: "StarIcon")
        view.addSubview(starImage)
        
        starTextLabel = UILabel()
        starTextLabel.translatesAutoresizingMaskIntoConstraints = false
        starTextLabel.text = "Что будем отслеживать?"
        starTextLabel.font = .systemFont(ofSize: 12, weight: .regular)
        starTextLabel.textColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        starTextLabel.textAlignment = .center
        view.addSubview(starTextLabel)
        
        NSLayoutConstraint.activate([
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            starTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starTextLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
        ])
    }
    
    private func shareAllCategories(categoriesList: [TrackerCategory]) -> [String] {
        return categoriesList.map { $0.categoryTitle }
    }
    
    private func setupWithTrackers() {
        starImage?.removeFromSuperview()
        starTextLabel?.removeFromSuperview()
        starImage = nil
        starTextLabel = nil
        
        trackerCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackerCollection.translatesAutoresizingMaskIntoConstraints = false
        trackerCollection.register(TrackerCell.self, forCellWithReuseIdentifier: "OneTracker")
        trackerCollection.register(TrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        trackerCollection.dataSource = self
        trackerCollection.delegate = self
        view.addSubview(trackerCollection)
        
        NSLayoutConstraint.activate([
            trackerCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            trackerCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension TrackersVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].categoryTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneTracker", for: indexPath) as? TrackerCell
        cell?.dataModel = categories[indexPath.section].categoryTrackers[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! TrackerHeader
        header.headerText = categories[indexPath.section].categoryTitle
        return header
    }
}

extension TrackersVC: UICollectionViewDelegate {
    
}

extension TrackersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 7) / CGFloat(2)
        return CGSize(width: cellWidth, height: cellWidth * 0.88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
    }
}

extension TrackersVC: TrackerSpecsDelegate {
    func didReceiveCategoriesList(newList: [String]) {
        let newUniqueElements = newList.filter({ !allPossibleCategories.contains($0) })
        allPossibleCategories.append(contentsOf: newUniqueElements)
    }
    
    func didReceiveNewTracker(newTrackerCategory: TrackerCategory) {
        if categories.isEmpty {
            setupWithTrackers()
            categories.append(newTrackerCategory)
            trackerCollection.reloadData()
        } else {
            if let index = categories.firstIndex(where: {$0.categoryTitle == newTrackerCategory.categoryTitle}) {
                categories[index].categoryTrackers.append(contentsOf: newTrackerCategory.categoryTrackers)
                let indexPath = IndexPath(item: categories[index].categoryTrackers.count-1, section: index)
                trackerCollection.insertItems(at: [indexPath])
            }
            else {
                categories.append(newTrackerCategory)
                let sectionIndex = categories.count - 1
                trackerCollection.insertSections(IndexSet(integer: sectionIndex))
            }
        }
    }
}
