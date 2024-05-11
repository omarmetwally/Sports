//
//  Coach.swift
//  Sports
//
//  Created by user242921 on 5/11/24.
//

import Foundation
// MARK: - Coach
struct Coach: Codable {
    let coachName: String?
    let coachCountry, coachAge: JSONNull?

    enum CodingKeys: String, CodingKey {
        case coachName = "coach_name"
        case coachCountry = "coach_country"
        case coachAge = "coach_age"
    }
}
