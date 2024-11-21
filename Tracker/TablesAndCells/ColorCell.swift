//
//  ColorCell.swift
//  Tracker
//
//  Created by Sergey Telnov on 20/11/2024.
//

import Foundation
import UIKit

final class ColorCell: UICollectionViewCell {
    
    var colorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmojiCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmojiCell() {
        
        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 8
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
