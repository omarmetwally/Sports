//
//  TeamCell.swift
//  Sports
//
//  Created by user242921 on 5/11/24.
//

import UIKit

class TeamCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cellSpacing: CGFloat = 10
        let horizontalMargin: CGFloat = 20
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: cellSpacing / 2, left: horizontalMargin, bottom: cellSpacing / 2, right: horizontalMargin))
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
