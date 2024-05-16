//
//  LeagueTableViewCell.swift
//  Sports
//
//  Created by Omar on 10/05/2024.
//
import UIKit
import Kingfisher

class LeagueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leagueLogoImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        
    }
    
    func configure(with league: League) {
        let processor = DownsamplingImageProcessor(size: leagueLogoImageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 40)
        leagueNameLabel.text = league.leagueName
        //        countryNameLabel.text = league.countryName
        
        leagueLogoImageView.kf.indicatorType = .activity
        leagueLogoImageView.kf.setImage(
            with: league.displayedLeagueLogo,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    private func setupCardStyle() {
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        leagueLogoImageView.layer.borderWidth = 1
        leagueLogoImageView.layer.borderColor = UIColor.black.cgColor
        leagueLogoImageView.layer.cornerRadius = 40
        leagueLogoImageView.contentMode = .scaleAspectFit
        leagueLogoImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellSpacing: CGFloat = 10
        let horizontalMargin: CGFloat = 20
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: cellSpacing / 2, left: horizontalMargin, bottom: cellSpacing / 2, right: horizontalMargin))
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    
    
}

