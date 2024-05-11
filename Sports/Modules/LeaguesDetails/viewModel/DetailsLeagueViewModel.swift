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

    init(networkService: NetworkProtocol, leagueId: String) {
        self.networkService = networkService
        self.leagueId = leagueId
    }

    func fetchEvents(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.string(from: Date())
        let endDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 15, to: Date())!)

        let endpoint = "Fixtures&leagueid=\(leagueId)&from=\(startDate)&to=\(endDate)"
        networkService.fetchData(sport: .football, endpoint: endpoint, decodingType: EventsResponse.self) { [weak self] result in
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
