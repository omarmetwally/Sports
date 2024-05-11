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
    }
}
    
