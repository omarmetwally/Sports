//
//  DetailsLeagueViewModel.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import Foundation


class DetailsLeagueViewModel {
    var events: [Event] = []
    var latestResults: [Event] = []
    var teams:[Team] = []
    private let networkService: NetworkProtocol
    private let leagueId: String
    private let league:League
     let sportName: Sport
    private let coreDataService:CoreDataProtocol

    init(networkService: NetworkProtocol,coreDataService : CoreDataProtocol, leagueId: String,sportName:Sport,league:League) {
        self.networkService = networkService
        self.coreDataService=coreDataService
        self.leagueId = leagueId
        self.sportName=sportName
        self.league=league
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
    
    func fetchLatestResults(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = dateFormatter.string(from: Date())
        let startDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -5, to: Date())!)

        let endpoint = "Fixtures&leagueid=\(leagueId)&from=\(startDate)&to=\(endDate)"
        networkService.fetchData(sport: sportName, endpoint: endpoint, decodingType: EventsResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventsResponse):
                    self?.latestResults = eventsResponse.result
                    completion()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion()
                }
            }
        }
    }
    func fetchTeams (completion: @escaping () -> Void) {
        networkService.fetchDataWithLeagueId(sport: sportName,id: Int(leagueId) ?? 0, endpoint: "Teams", decodingType: TeamResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teamResponse):
                    self?.teams = teamResponse.result
                    completion()
                case .failure(let error):
                    print("Error fetching leagues: \(error.localizedDescription)")
                    completion()
                }
            }
        }
    }
    func addToFav(){
        coreDataService.addLeague(league: league )
    }
    func isStored()->Bool{
       return coreDataService.isLeagueSaved(leagueId: Int(leagueId) ?? 0)
    }
}
