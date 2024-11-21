//
//  EmojiCell.swift
//  Tracker
//
//  Created by Sergey Telnov on 19/11/2024.
//

import Foundation
import UIKit

final class EmojiCell: UICollectionViewCell {
    
    var emojiCellLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmojiCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmojiCell() {
        
        emojiCellLabel = UILabel()
        emojiCellLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiCellLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        contentView.addSubview(emojiCellLabel)
        
        NSLayoutConstraint.activate([
            emojiCellLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiCellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
