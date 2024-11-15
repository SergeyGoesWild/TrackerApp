//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 05/11/2024.
//

import Foundation
import UIKit

final class TrackersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var categories: [TrackerCategory]?
    var completedTrackers: [TrackerRecord]?
    
    var trackerCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerScreen()
    }
    
    @objc
    private func plusButtonPressed() {
        print("Plus button PRESSED")
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneTracker", for: indexPath) as? TrackerCell
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth = (collectionView.bounds.width - 10) / CGFloat(2)
        return CGSize(width: cellWidth, height: cellWidth * 0.88)
    }
    
    private func setupTrackerScreen() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        
        let plusButton = UIButton()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setImage(UIImage(named: "PlusIconSVG"), for: .normal)
        plusButton.setTitle("", for: .normal)
        plusButton.tintColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        view.addSubview(plusButton)
        
        let datePicker = UIDatePicker()
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
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        
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
        
        trackerCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackerCollection.translatesAutoresizingMaskIntoConstraints = false
        trackerCollection.register(TrackerCell.self, forCellWithReuseIdentifier: "OneTracker")
        trackerCollection.dataSource = self
        trackerCollection.delegate = self
        view.addSubview(trackerCollection)
        
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
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starTextLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            trackerCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            trackerCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
