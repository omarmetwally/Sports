//
//  Event.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import Foundation

struct EventsResponse: Codable {
    let success: Int
    let result: [Event]
}


struct Event: Codable {
    var eventKey: Int
    var eventDate: String
    var eventTime: String
    var homeTeam: String
    var awayTeam: String
    var homeTeamLogo: URL?
    var awayTeamLogo: URL?
    
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case homeTeam = "event_home_team"
        case awayTeam = "event_away_team"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case firstPlayer = "event_first_player"
        case secondPlayer = "event_second_player"
        case firstPlayerLogo = "event_first_player_logo"
        case secondPlayerLogo = "event_second_player_logo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventKey = try container.decode(Int.self, forKey: .eventKey)
        eventDate = try container.decode(String.self, forKey: .eventDate)
        eventTime = try container.decode(String.self, forKey: .eventTime)
        
        if let homeTeam = try container.decodeIfPresent(String.self, forKey: .homeTeam) {
            self.homeTeam = homeTeam
            self.awayTeam = try container.decode(String.self, forKey: .awayTeam)
            self.homeTeamLogo = try container.decodeIfPresent(URL.self, forKey: .homeTeamLogo)
            self.awayTeamLogo = try container.decodeIfPresent(URL.self, forKey: .awayTeamLogo)
        } else {
            self.homeTeam = try container.decode(String.self, forKey: .firstPlayer)
            self.awayTeam = try container.decode(String.self, forKey: .secondPlayer)
            self.homeTeamLogo = try container.decodeIfPresent(URL.self, forKey: .firstPlayerLogo)
            self.awayTeamLogo = try container.decodeIfPresent(URL.self, forKey: .secondPlayerLogo)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventKey, forKey: .eventKey)
        try container.encode(eventDate, forKey: .eventDate)
        try container.encode(eventTime, forKey: .eventTime)
        try container.encode(homeTeam, forKey: .homeTeam)
        try container.encode(awayTeam, forKey: .awayTeam)
        try container.encode(homeTeamLogo, forKey: .homeTeamLogo)
        try container.encode(awayTeamLogo, forKey: .awayTeamLogo)
    }
}
