//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 05/11/2024.
//

import Foundation
import UIKit

protocol TrackerSpecsDelegate {
    func didReceiveNewTracker(newTrackerCategory: TrackerCategory)
}

final class TrackersVC: UIViewController {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    var titleLabel: UILabel!
    var plusButton: UIButton!
    var datePicker: UIDatePicker!
    var searchBar: UISearchBar!
    var trackerCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tracker1 = Tracker(trackerID: UUID(), trackerName: "Считать звезды", color: UIColor(red: 0.20, green: 0.81, blue: 0.41, alpha: 1.00), emoji: "✨", schedule: ["Saturday"])
        let tracker2 = Tracker(trackerID: UUID(), trackerName: "Выглядеть классно", color: UIColor(red: 0.99, green: 0.30, blue: 0.29, alpha: 1.00), emoji: "😎", schedule: ["Tuesday", "Friday"])
        let tracker3 = Tracker(trackerID: UUID(), trackerName: "Смотреть на закат", color: UIColor(red: 0.47, green: 0.58, blue: 0.96, alpha: 1.00), emoji: "🌇", schedule: ["Monday", "Tuesday", "Sunday"])
        let category1 = TrackerCategory(categoryTitle: "Очень важно", categoryTrackers: [tracker1])
        categories.append(category1)
        let category2 = TrackerCategory(categoryTitle: "Не очень важно", categoryTrackers: [tracker2, tracker3, tracker3])
        categories.append(category2)
        setupTrackerScreen()
    }
    
    @objc
    private func plusButtonPressed() {
        let modalVC = NewTrackerTypeVC()
        modalVC.delegateLink = self
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
        
        //TODO: насторить звезду по середине видимой части
        //TODO: проверить поля у этого элемента, они как будто больше
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
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
        ])
    }
    
    private func setupNoTrackers() {
        let starImage = UIImageView()
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.image = UIImage(named: "StarIcon")
        view.addSubview(starImage)
        
        let starTextLabel = UILabel()
        starTextLabel.translatesAutoresizingMaskIntoConstraints = false
        starTextLabel.text = "Что будем отслеживать?"
        starTextLabel.font = .systemFont(ofSize: 12, weight: .regular)
        starTextLabel.textColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        starTextLabel.textAlignment = .center
        view.addSubview(starTextLabel)
        
        NSLayoutConstraint.activate([
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starTextLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
        ])
    }
    
    private func setupWithTrackers() {
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
    func didReceiveNewTracker(newTrackerCategory: TrackerCategory) {
        if let index = categories.firstIndex(where: {$0.categoryTitle == newTrackerCategory.categoryTitle}) {
            categories[index].categoryTrackers.append(contentsOf: newTrackerCategory.categoryTrackers)
            let indexPath = IndexPath(item: categories[index].categoryTrackers.count-1, section: index)
            trackerCollection.insertItems(at: [indexPath])
        }
        else {
            categories.append(newTrackerCategory)
            let sectionIndex = categories.count - 1
            trackerCollection.insertSections(IndexSet(integer: sectionIndex))
            //TODO: нужен здесь reloadData?????
        }
    }
}
