//
//  EmojiHeader.swift
//  Tracker
//
//  Created by Sergey Telnov on 19/11/2024.
//

import Foundation
import UIKit

final class NewTrackerHeader: UICollectionReusableView {
    
    var newHeaderLabel: UILabel!
    var labelText: String? {
        didSet {
            newHeaderLabel.text = labelText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmojiHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmojiHeaderView() {
        newHeaderLabel = UILabel()
        newHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        newHeaderLabel.text = labelText
        newHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addSubview(newHeaderLabel)
        
        NSLayoutConstraint.activate([
            newHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            newHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            newHeaderLabel.topAnchor.constraint(equalTo: topAnchor),
            newHeaderLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
