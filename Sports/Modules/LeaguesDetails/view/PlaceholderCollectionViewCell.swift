//
//  PlaceholderCollectionViewCell.swift
//  Sports
//
//  Created by Omar on 14/05/2024.
//

import Foundation
import UIKit

class PlaceholderCollectionViewCell: UICollectionViewCell {
    private let messageImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(messageImageView)
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: messageImageView.widthAnchor).isActive = true
        messageImageView.image = UIImage(named: "noDataFound")
    }
}
