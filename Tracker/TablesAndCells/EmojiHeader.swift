//
//  EmojiHeader.swift
//  Tracker
//
//  Created by Sergey Telnov on 19/11/2024.
//

import Foundation
import UIKit

final class EmojiHeader: UICollectionReusableView {
    
    var emojiHeaderLabel: UILabel!
    var labelText: String? {
        didSet {
            emojiHeaderLabel.text = labelText
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
        emojiHeaderLabel = UILabel()
        emojiHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiHeaderLabel.text = labelText
        emojiHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addSubview(emojiHeaderLabel)
        
        NSLayoutConstraint.activate([
            emojiHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emojiHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiHeaderLabel.topAnchor.constraint(equalTo: topAnchor),
            emojiHeaderLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
