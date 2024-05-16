//
//  SportsCollectionViewCell.swift
//  Sports
//
//  Created by user242921 on 5/10/24.
//

import UIKit

class SportsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sportNameLabel: UILabel!
    @IBOutlet weak var sportImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath

        sportImage.layer.cornerRadius = 10
        sportImage.clipsToBounds = true
        sportImage.contentMode = .scaleAspectFill

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
}
