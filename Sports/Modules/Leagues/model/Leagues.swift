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
    var sport: Sport?
    
    init(_ entity: LeagueCD) {
        self.leagueKey = Int(entity.leagueKey)
        self.leagueName = entity.leagueName ?? ""
        self.leagueLogo = URL(string:entity.leagueLogo ?? "") ?? URL(string: "")
        countryKey = 1
        countryName = "placeHolder"
        self.countryLogo = URL(string: "")
        self.sport = Sport(rawValue: entity.sport ?? "")

        
    }

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
    
    
    
    
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            leagueKey = try container.decode(Int.self, forKey: .leagueKey)
            leagueName = try container.decode(String.self, forKey: .leagueName)
            countryKey = try container.decode(Int.self, forKey: .countryKey)
            countryName = try container.decode(String.self, forKey: .countryName)

            if let leagueLogoString = try container.decodeIfPresent(String.self, forKey: .leagueLogo) {
                leagueLogo = URL(string: leagueLogoString)
            } else {
                leagueLogo = nil
            }

            if let countryLogoString = try container.decodeIfPresent(String.self, forKey: .countryLogo) {
                countryLogo = URL(string: countryLogoString)
            } else {
                countryLogo = nil
            }
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

extension League {
    //extension for testing
    init(leagueKey: Int, leagueName: String, countryKey: Int, countryName: String, leagueLogo: URL?, countryLogo: URL?, sport: Sport?) {
        self.leagueKey = leagueKey
        self.leagueName = leagueName
        self.countryKey = countryKey
        self.countryName = countryName
        self.leagueLogo = leagueLogo
        self.countryLogo = countryLogo
        self.sport = sport
    }
}
