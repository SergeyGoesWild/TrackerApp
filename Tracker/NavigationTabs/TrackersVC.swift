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
}

final class TrackersVC: UIViewController {
    
    var defaultCategory: [String] = ["Важные дела"]
    var currentDate: Date!
    
    var starImage: UIImageView!
    var starTextLabel: UILabel!
    var titleLabel: UILabel!
    var plusButton: UIButton!
    var datePicker: UIDatePicker!
    var searchBar: UISearchBar!
    var trackerCollection: UICollectionView!
    var dataProvider: DataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerScreen()
        dataProvider = DataProvider(trackerCollection: trackerCollection)
        dataProvider.purgeAllData()
        dateDidChange()
    }
    
    @objc
    private func plusButtonPressed() {
        let modalVC = NewTrackerTypeVC()
        modalVC.delegateLink = self
        let allPossibleTitles = dataProvider.getAllPossibleTitles()
        if allPossibleTitles.contains(where: {$0 == defaultCategory[0]}) {
            modalVC.delegateListShare = allPossibleTitles
        } else {
            modalVC.delegateListShare = allPossibleTitles + defaultCategory
        }
        let navController = UINavigationController(rootViewController: modalVC)
        present(navController, animated: true)
    }
    
    @objc private func dateDidChange() {
        let dateFromDatePicker = datePicker.date
        let calendar = Calendar.current
        currentDate = calendar.startOfDay(for: dateFromDatePicker)
        filterDateChange()
    }
    
    private func filterDateChange() {
        let currentDayOfWeek = getCurrentDayOfWeek(date: currentDate)
        dataProvider.performFetchByDay(for: currentDayOfWeek)
        
        if dataProvider.numberOfSections() > 0 {
            displayEmptyScreen(isActive: false)
            trackerCollection.reloadData()
        } else {
            displayEmptyScreen(isActive: true)
        }
    }
    
    private func getCurrentDayOfWeek(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDayOfWeek = dateFormatter.string(from: date)
        return currentDayOfWeek
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
        
        datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
        
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
        
        trackerCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackerCollection.translatesAutoresizingMaskIntoConstraints = false
        trackerCollection.register(TrackerCell.self, forCellWithReuseIdentifier: "OneTracker")
        trackerCollection.register(TrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        trackerCollection.dataSource = self
        trackerCollection.delegate = self
        view.addSubview(trackerCollection)
        
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
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            trackerCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            trackerCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            starTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starTextLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
        ])
    }
    
    private func displayEmptyScreen(isActive: Bool) {
        starImage.isHidden = !isActive
        starTextLabel.isHidden = !isActive
        trackerCollection.isHidden = isActive
    }
    
    private func isTrackerCompleteCurrentDate(id: UUID) -> Bool {
        let result = dataProvider.checkRecordExist(with: id, at: currentDate)
        return result
    }
}

extension TrackersVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataProvider.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tracker = dataProvider.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneTracker", for: indexPath) as? TrackerCell
        cell?.delegate = self
        cell?.dataModel = tracker
        cell?.currentDate = currentDate
        cell?.indexPath = indexPath
        cell?.completeDays = dataProvider.getCompleteDays(for: tracker.trackerID)
        cell?.isComplete = isTrackerCompleteCurrentDate(id: tracker.trackerID)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? TrackerHeader
        header?.headerText = dataProvider.category(for: indexPath.section)
        return header ?? UICollectionReusableView()
    }
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
        if dataProvider.fetchTrackerCategory(by: newTrackerCategory.categoryTitle) != nil {
            dataProvider.updateTrackerCategory(title: newTrackerCategory.categoryTitle, newTracker: newTrackerCategory.categoryTrackers[0])
        }
        else {
            dataProvider.createTrackerCategory(categoryTitle: newTrackerCategory.categoryTitle)
            dataProvider.updateTrackerCategory(title: newTrackerCategory.categoryTitle, newTracker: newTrackerCategory.categoryTrackers[0])
        }
        filterDateChange()
    }
}

extension TrackersVC: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        dataProvider.createRecord(with: id, for: currentDate)
        trackerCollection.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        do {
            try dataProvider.deleteRecord(with: id, for: currentDate)
        }
        catch {
            print("Ошибка при удалении элемента")
        }
        trackerCollection.reloadItems(at: [indexPath])
    }
}
