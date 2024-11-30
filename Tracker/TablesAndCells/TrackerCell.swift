//
//  TrackerCell.swift
//  Tracker
//
//  Created by Sergey Telnov on 13/11/2024.
//

import Foundation
import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    var isComplete: Bool? {
        didSet {
            guard let isComplete = isComplete else { return }
            if isComplete {
                addDayButton.setImage(UIImage(named: "CheckIcon")?.withTintColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)), for: .normal)
                addDayButton.backgroundColor?.withAlphaComponent(0.30)
            } else {
                addDayButton.setImage(UIImage(named: "PlusIconSVG")?.withTintColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)), for: .normal)
                addDayButton.backgroundColor?.withAlphaComponent(1.00)
            }
        }
    }
    var dataModel: Tracker? {
        didSet {
            guard let dataModel = dataModel else { return }
            coloredBackground.backgroundColor = dataModel.color
            emojiLabel.text = dataModel.emoji
            titleLabel.text = dataModel.trackerName
            addDayButton.backgroundColor = dataModel.color
        }
    }
    var indexPath: IndexPath?
    var completeDays: Int? {
        didSet {
            dayLabel.text = pluralizeDays(completeDays ?? 0)
        }
    }
    
    var coloredBackground: UIView!
    var emojiCircle: UIView!
    var emojiLabel: UILabel!
    var titleLabel: UILabel!
    var dayLabel: UILabel!
    var addDayButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTrackerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTrackerView() {
        
        coloredBackground = UIView()
        coloredBackground.translatesAutoresizingMaskIntoConstraints = false
        coloredBackground.layer.cornerRadius = CGFloat(16)
        contentView.addSubview(coloredBackground)
        
        emojiCircle = UIView()
        emojiCircle.translatesAutoresizingMaskIntoConstraints = false
        emojiCircle.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.30)
        emojiCircle.layer.cornerRadius = CGFloat(12)
        contentView.addSubview(emojiCircle)
        
        emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        contentView.addSubview(emojiLabel)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.text = ""
        dayLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(dayLabel)
        
        addDayButton = UIButton()
        addDayButton.translatesAutoresizingMaskIntoConstraints = false
        addDayButton.setImage(UIImage(named: "PlusIconSVG")?.withTintColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)), for: .normal)
        addDayButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addDayButton.layer.cornerRadius = 17
        addDayButton.addTarget(self, action: #selector(addDayPressed), for: .touchUpInside)
        contentView.addSubview(addDayButton)
        
        NSLayoutConstraint.activate([
            coloredBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            coloredBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coloredBackground.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            coloredBackground.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            emojiCircle.topAnchor.constraint(equalTo: coloredBackground.topAnchor, constant: 12),
            emojiCircle.leadingAnchor.constraint(equalTo: coloredBackground.leadingAnchor, constant: 12),
            emojiCircle.widthAnchor.constraint(equalToConstant: 24),
            emojiCircle.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiCircle.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiCircle.centerYAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: coloredBackground.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: coloredBackground.leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: coloredBackground.bottomAnchor, constant: 16),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            addDayButton.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            addDayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addDayButton.widthAnchor.constraint(equalToConstant: 34),
            addDayButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    @objc private func addDayPressed() {
        guard let isComplete = isComplete else { return }
        guard let indexPath = indexPath else { return }
        if isComplete {
            delegate?.uncompleteTracker(id: dataModel!.trackerID, at: indexPath)
        } else {
            delegate?.completeTracker(id: dataModel!.trackerID, at: indexPath)
        }
    }
    
    private func pluralizeDays(_ count: Int) -> String {
        let form = count % 100 > 10 && count % 100 < 20 ? 2 : (count % 10 == 1 ? 0 : (count % 10 >= 2 && count % 10 <= 4 ? 1 : 2))
        let forms = ["день", "дня", "дней"]
        return "\(count) \(forms[form])"
    }
}
