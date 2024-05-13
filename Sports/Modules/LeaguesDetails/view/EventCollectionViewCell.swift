//
//  EventCollectionViewCell.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import UIKit
import Kingfisher


class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var homeTeamLogoImageView: UIImageView!
    @IBOutlet weak var awayTeamLogoImageView: UIImageView!
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    func configure(with event: Event) {
        
        
        let processor = DownsamplingImageProcessor(size: homeTeamLogoImageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 25)
        
        awayTeamNameLabel.text = event.awayTeam
        homeTeamNameLabel.text=event.homeTeam
        eventDateLabel.text = Helper.formattedDate(from: event.eventDate)
        eventTimeLabel.text = event.eventTime
        scoreLabel.text=event.finalResult

        
        homeTeamLogoImageView.kf.indicatorType = .activity
        homeTeamLogoImageView.kf.setImage(
            with: event.homeTeamLogo,
            placeholder: UIImage(named: "badge-placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        
        awayTeamLogoImageView.kf.indicatorType = .activity
        awayTeamLogoImageView.kf.setImage(
            with: event.awayTeamLogo,
            placeholder: UIImage(named: "badge-placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        
    }
}

