//
//  DetailsLeagueViewModel.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import Foundation


class DetailsLeagueViewModel {
    var events: [Event] = []
    private let networkService: NetworkProtocol
    private let leagueId: String
    private let sportName: Sport

    init(networkService: NetworkProtocol, leagueId: String,sportName:Sport) {
        self.networkService = networkService
        self.leagueId = leagueId
        self.sportName=sportName
    }

    func fetchEvents(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.string(from: Date())
        let endDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 15, to: Date())!)

        let endpoint = "Fixtures&leagueid=\(leagueId)&from=\(startDate)&to=\(endDate)"
        networkService.fetchData(sport: sportName, endpoint: endpoint, decodingType: EventsResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventsResponse):
                    self?.events = eventsResponse.result.reversed()
                    completion()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion()
                }
            }
        }
    }
}
