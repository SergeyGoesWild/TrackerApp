//
//  TrackerHeader.swift
//  Tracker
//
//  Created by Sergey Telnov on 15/11/2024.
//

import Foundation
import UIKit

final class TrackerHeader: UICollectionReusableView {
    
    var headerLabel: UILabel!
    var headerText: String? {
        didSet {
            headerLabel.text = headerText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeaderView() {
        headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = headerText
        headerLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
