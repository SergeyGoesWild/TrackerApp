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
    var outlineView: UIView!
    
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
        
        outlineView = UIView()
        outlineView.translatesAutoresizingMaskIntoConstraints = false
        outlineView.layer.cornerRadius = 8
        outlineView.layer.borderWidth = 0
        outlineView.layer.borderColor = nil
        contentView.addSubview(outlineView)
        
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            outlineView.heightAnchor.constraint(equalToConstant: 46),
            outlineView.widthAnchor.constraint(equalToConstant: 46),
            outlineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            outlineView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
