//
//  NewTrackerSpecs.swift
//  Tracker
//
//  Created by Sergey Telnov on 18/11/2024.
//

import Foundation
import UIKit

protocol CommonSpecsDelegate: AnyObject {
    func didChooseEmoji(emojiToShare: String)
    func didChooseColor(colorToShare: UIColor)
}

final class NewTrackerSpecsVC: UIViewController {
    
    var newTrackerType: trackerTypes?
    weak var delegate: TrackerSpecsDelegate?
    
    var chosenCategory: String?
    var chosenTitle: String?
    var chosenColor: UIColor?
    var chosenEmoji: String?
    var chosenSchedule: [dayOfWeek]?
    var possibleCategories: [String] = []
    
    var previousChosenEmojiCell: EmojiCell?
    var previousChosenColorCell: ColorCell?
    
    let headerList = ["Emoji", "Цвет"]
    var specsList = [(title: "Категория", subtitle: nil as String?), (title: "Расписание", subtitle: nil as String?)]
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
    var warningLabel: UILabel!
    var specsTable: UITableView!
    var emojiCollection: UICollectionView!
    var colorCollection: UICollectionView!
    var createButton: UIButton!
    var cancelButton: UIButton!
    
    var specsTableTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerSpecsView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    @objc private func createButtonPressed() {
            if let chosenCategory = chosenCategory,
               let chosenTitle = chosenTitle,
               let chosenColor = chosenColor,
               let chosenEmoji = chosenEmoji {
                formNewTracker(chosenCategory: chosenCategory, chosenTitle: chosenTitle, chosenColor: chosenColor, chosenEmoji: chosenEmoji, chosenSchedule: chosenSchedule)
            }
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 38 {
                showWarning()
                let start = text.startIndex
                let end = text.index(start, offsetBy: 38)
                let slice = text[start..<end]
                titleTextField.text = String(slice)
            } else {
                hideWarning()
                chosenTitle = textField.text
                if chosenTitle == "" { chosenTitle = nil }
                checkTrackerState()
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func clearTextField() {
        titleTextField.text = ""
    }
    
    private func showWarning() {
        warningLabel.isHidden = false
        specsTableTopConstraint.constant = 62
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideWarning() {
        warningLabel.isHidden = true
        specsTableTopConstraint.constant = 24
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func formNewTracker(chosenCategory: String, chosenTitle: String, chosenColor: UIColor, chosenEmoji: String, chosenSchedule: [dayOfWeek]?) {
        let newTracker = Tracker(trackerID: UUID(), trackerName: chosenTitle, color: chosenColor, emoji: chosenEmoji, schedule: chosenSchedule?.map( {$0.engName} ))
        let newTrackerCategory = TrackerCategory(categoryTitle: chosenCategory, categoryTrackers: [newTracker])
        delegate?.didReceiveNewTracker(newTrackerCategory: newTrackerCategory)
        delegate?.didReceiveCategoriesList(newList: possibleCategories)
        dismiss(animated: true, completion: nil)
    }
    
    private func checkTrackerState() {
        if newTrackerType == .habit {
            if let chosenCategory = chosenCategory,
               let chosenTitle = chosenTitle,
               let chosenColor = chosenColor,
               let chosenEmoji = chosenEmoji,
               let chosenSchedule = chosenSchedule {
                enableDoneButton()
            } else {
                disableDoneButton()
            }
        } else {
            if let chosenCategory = chosenCategory,
               let chosenTitle = chosenTitle,
               let chosenColor = chosenColor,
               let chosenEmoji = chosenEmoji {
                enableDoneButton()
            } else {
                disableDoneButton()
            }
        }
    }
    
    private func enableDoneButton() {
        createButton.isEnabled = true
        createButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
    }
    
    private func disableDoneButton() {
        createButton.isEnabled = false
        createButton.backgroundColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
    }

    
    private func setupTrackerSpecsView() {
        view.backgroundColor = .white
        navigationItem.title = newTrackerType == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        navigationItem.hidesBackButton = true
        
        specsList = newTrackerType == .habit ?
        [(title: "Категория", subtitle: nil as String?), (title: "Расписание", subtitle: nil as String?)] :
        [(title: "Категория", subtitle: nil as String?)]
        
        specsScrollView = UIScrollView()
        specsScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(specsScrollView)
        
        specsContainer = UIView()
        specsContainer.translatesAutoresizingMaskIntoConstraints = false
        specsScrollView.addSubview(specsContainer)
        
        titleTextField = UITextField()
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.layer.cornerRadius = 16
        titleTextField.placeholder = "Введите название трекера"
        titleTextField.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        titleTextField.font = UIFont.systemFont(ofSize: 17)
        let clearButton = UIButton(type: .system)
        clearButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        titleTextField.rightView = clearButton
        titleTextField.clearButtonMode = .whileEditing
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: titleTextField.frame.height))
        titleTextField.leftView = leftPaddingView
        titleTextField.leftViewMode = .always
        specsContainer.addSubview(titleTextField)
        
        warningLabel = UILabel()
        warningLabel.text = "Ограничение 38 символов"
        warningLabel.font = .systemFont(ofSize: 17)
        warningLabel.textAlignment = .center
        warningLabel.isHidden = true
        warningLabel.textColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        specsContainer.addSubview(warningLabel)
        
        specsTable = UITableView(frame: .zero, style: .plain)
        specsTable.dataSource = self
        specsTable.delegate = self
        specsTable.register(UITableViewCell.self, forCellReuseIdentifier: "specsCellTitle")
        specsTable.register(UITableViewCell.self, forCellReuseIdentifier: "specsCellSubtitle")
        specsTable.translatesAutoresizingMaskIntoConstraints = false
        specsTable.layer.cornerRadius = 16
        specsTable.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        specsContainer.addSubview(specsTable)
        
        emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollection.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiCollection.register(NewTrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "newTrackerHeader")
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        emojiCollection.delegate = self
        emojiCollection.dataSource = self
        emojiCollection.tag = 1
        specsContainer.addSubview(emojiCollection)
        
        colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorCollection.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        colorCollection.register(NewTrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "newTrackerHeader")
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        colorCollection.delegate = self
        colorCollection.dataSource = self
        colorCollection.tag = 2
        specsContainer.addSubview(colorCollection)
        
        createButton = UIButton(type: .system)
        createButton.setTitle("Создать", for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        createButton.setTitleColor(.white, for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        specsContainer.addSubview(createButton)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00).cgColor
        cancelButton.setTitleColor(UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00), for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        specsContainer.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            specsScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            specsScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            specsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            specsScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            specsContainer.topAnchor.constraint(equalTo: specsScrollView.topAnchor),
            specsContainer.leadingAnchor.constraint(equalTo: specsScrollView.leadingAnchor),
            specsContainer.trailingAnchor.constraint(equalTo: specsScrollView.trailingAnchor),
            specsContainer.bottomAnchor.constraint(equalTo: specsScrollView.bottomAnchor),
            specsContainer.widthAnchor.constraint(equalTo: specsScrollView.widthAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: specsContainer.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            warningLabel.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 44),
            warningLabel.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -44),
            warningLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            
            specsTable.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 16),
            specsTable.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -16),
            specsTable.heightAnchor.constraint(equalToConstant: CGFloat(75*specsList.count)),
            
            emojiCollection.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 18),
            emojiCollection.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -18),
            emojiCollection.topAnchor.constraint(equalTo: specsTable.bottomAnchor, constant: 32),
            emojiCollection.heightAnchor.constraint(equalToConstant: 204+18),
            
            colorCollection.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 18),
            colorCollection.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -18),
            colorCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 16),
            colorCollection.heightAnchor.constraint(equalToConstant: 204+18),
            
            createButton.leadingAnchor.constraint(equalTo: specsContainer.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: specsContainer.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor),
            createButton.bottomAnchor.constraint(equalTo: specsContainer.bottomAnchor, constant: -16),
            
            cancelButton.leadingAnchor.constraint(equalTo: specsContainer.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: specsContainer.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: specsContainer.bottomAnchor, constant: -16),
        ])
        specsTableTopConstraint = specsTable.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24)
        specsTableTopConstraint.isActive = true
    }
}

extension NewTrackerSpecsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell {
                if let previousChosenEmojiCell {
                    previousChosenEmojiCell.backgroundColor = nil
                }
                chosenEmoji = cell.emojiCellLabel.text
                cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.00)
                cell.layer.cornerRadius = 16
                previousChosenEmojiCell = cell
                checkTrackerState()
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell {
                if let previousChosenColorCell {
                    previousChosenColorCell.layer.borderColor = nil
                    previousChosenColorCell.layer.borderWidth = 0
                }
                chosenColor = cell.colorView.backgroundColor
                cell.layer.borderColor = UIColor(red: 0.20, green: 0.81, blue: 0.41, alpha: 0.30).cgColor
                cell.layer.borderWidth = 3
                cell.layer.cornerRadius = 8
                previousChosenColorCell = cell
                checkTrackerState()
            }
        }
    }
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
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "newTrackerHeader",
            for: indexPath) as! NewTrackerHeader
        header.labelText = headerList[collectionView.tag - 1]
        return header
    }
}

extension NewTrackerSpecsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

extension NewTrackerSpecsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalHeight = tableView.bounds.height
        let rowHeight = totalHeight / CGFloat(specsList.count)
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        switch selectedCell?.textLabel?.text {
        case "Категория":
            tableView.deselectRow(at: indexPath, animated: true)
            let nextScreen = CategoryListVC()
            nextScreen.categoryList.append(contentsOf: possibleCategories)
            nextScreen.delegate = self
            if let chosenCategory {
                nextScreen.categorySelection = chosenCategory
            }
            navigationController?.pushViewController(nextScreen, animated: true)
        case "Расписание":
            tableView.deselectRow(at: indexPath, animated: true)
            let nextScreen = ScheduleVC()
            nextScreen.delegate = self
            if let chosenSchedule {
                nextScreen.scheduleSelection.append(contentsOf: chosenSchedule)
            }
            navigationController?.pushViewController(nextScreen, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            print("Ни один из вариантов")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

extension NewTrackerSpecsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = specsList[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.detailTextLabel?.textColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        return cell
    }
}

extension NewTrackerSpecsVC: ScheduleDelegateProtocol {
    func didSetSchedule(scheduleArray: [dayOfWeek]) {
        chosenSchedule = scheduleArray
        let stringToSubtitle = scheduleArray.map { $0.shortName }.joined(separator: ", ")
        specsList[1].subtitle = stringToSubtitle
        //TODO: заменить это на reloadRows
        specsTable.reloadData()
//        specsTable.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        checkTrackerState()
    }
}

extension NewTrackerSpecsVC: CategoryDelegateProtocol {
    func didAppendNewCategory(categoryTitle: String) {
        if possibleCategories.contains(where: {$0 == categoryTitle}) {
            return
        } else {
            possibleCategories.append(categoryTitle)
        }
    }
    
    func didReceiveChosenCategory(categoryTitle: String) {
        chosenCategory = categoryTitle
        specsList[0].subtitle = categoryTitle
        //TODO: заменить это на reloadRows
        specsTable.reloadData()
        checkTrackerState()
    }
}
