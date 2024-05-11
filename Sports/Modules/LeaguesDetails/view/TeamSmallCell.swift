//
//  TeamSmallCell.swift
//  Sports
//
//  Created by user242921 on 5/11/24.
//

import UIKit
import Kingfisher

class TeamSmallCell: UICollectionViewCell {
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    func configure(with team: Team) {
        
        
        let processor = DownsamplingImageProcessor(size: teamImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 25)
        
        teamName.text = team.teamName

        
        teamImage.kf.indicatorType = .activity
        teamImage.kf.setImage(
            with: URL(string:team.teamLogo ?? ""),
            placeholder: UIImage(named: "badge-placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
    }
}
