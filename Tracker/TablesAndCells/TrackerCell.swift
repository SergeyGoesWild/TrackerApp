//
//  TrackerCell.swift
//  Tracker
//
//  Created by Sergey Telnov on 13/11/2024.
//

import Foundation
import UIKit

final class TrackerCell: UICollectionViewCell {
    
    var dataModel: Tracker? {
        didSet {
            guard let dataModel = dataModel else { return }
            coloredBackground.backgroundColor = dataModel.color
            emojiLabel.text = dataModel.emoji
            titleLabel.text = dataModel.trackerName
            addDayButton.backgroundColor = dataModel.color
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
        emojiLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        contentView.addSubview(emojiLabel)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.text = getCounterText()
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
    
    //TODO: Написать функцию, которая реагирует на нажатия плюса на трекере
    @objc private func addDayPressed() {
        addDayButton.setImage(UIImage(named: "CheckIcon")?.withTintColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)), for: .normal)
        addDayButton.backgroundColor?.withAlphaComponent(0.30)
        
        //TODO: работаем с делегатом
    }
    
    //TODO: Написать функцию, которая будет формировать сообщение для счетчика
    private func getCounterText() -> String {
        return "\(getCounterDays()) день"
    }
    
    //TODO: Написать функцию, которая будет считать дни для счетчика
    private func getCounterDays() -> Int {
        return 1
    }
}
