//
//  Leagues.swift
//  Sports
//
//  Created by Omar on 10/05/2024.
//

import Foundation

struct LeagueResponse: Codable {
    let success: Int
    let result: [League]
}

struct League: Codable {
    let leagueKey: Int
    let leagueName: String
    let countryKey: Int
    let countryName: String
    let leagueLogo: URL?
    let countryLogo: URL?
    
    init(_ entity: LeagueCD) {
        self.leagueKey = Int(entity.leagueKey)
        self.leagueName = entity.leagueName ?? ""
        self.leagueLogo = URL(string:entity.leagueLogo ?? "") ?? URL(string: "")
        countryKey = 1
        countryName = "placeHolder"
        self.countryLogo = URL(string: "")

        
    }

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
}


extension League {
    var displayedLeagueLogo: URL {
        return leagueLogo ?? URL(string: "https://logo.com/image-cdn/images/kts928pd/production/998301e16cf7bed19803edf48fd7084130ab234d-335x334.png?w=1080&q=72")!
    }
    var displayedCountryLogo: URL {
        return countryLogo ?? URL(string: "default_country_logo_url")!
    }
}

