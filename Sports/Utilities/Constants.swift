//
//  Constants.swift
//  Sports
//
//  Created by Omar on 10/05/2024.
//

import Foundation


import Foundation

enum Sport: String {
    case football = "football"
    case basketball = "basketball"
    case cricket = "cricket"
    case tennis = "tennis"
}

struct Constants {
    static let apiKey = "401f04dc0fa67b084060b9388a3f77e7534eaa9d0194f16f2079a1839f8039e6"
    static func baseURL(for sport: Sport) -> String {
        return "https://apiv2.allsportsapi.com/\(sport.rawValue)/"
    }
}
