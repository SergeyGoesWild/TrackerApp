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
        emojiHeaderLabel.text = "Emoji"
        emojiHeaderLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        addSubview(emojiHeaderLabel)
        
        NSLayoutConstraint.activate([
            emojiHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiHeaderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
