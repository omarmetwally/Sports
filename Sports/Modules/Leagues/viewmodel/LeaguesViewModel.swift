//
//  LeaguesViewModel.swift
//  Sports
//
//  Created by Omar on 10/05/2024.
//

import Foundation

class LeaguesViewModel:LeaguesDisplayable  {
    private var networkService: NetworkProtocol
    var leagues: [League] = []
    var sport: Sport?

    init(networkService: NetworkProtocol, sport: Sport) {
        self.networkService = networkService
        self.sport = sport
    }

    func fetchData(completion: @escaping () -> Void) {
        print("Leagues fetchData")
        networkService.fetchData(sport: sport ?? .football, endpoint: "Leagues", decodingType: LeagueResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let leagueResponse):
                    self?.leagues = leagueResponse.result
                    completion()
                case .failure(let error):
                    print("Error fetching leagues: \(error.localizedDescription)")
                    completion()
                }
            }
        }
    }
}

