//
//  DetailsLeagueViewModel.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import Foundation

protocol DetailLeagueViewModelProtocol {
    var events: [Event] { get }
    var latestResults: [Event] { get }
    var teams: [Team] { get }
    var sportName: Sport { get }
    var delegate: FavoriteUpdateDelegate? {get set}
    
    func fetchEvents(completion: @escaping () -> Void)
    func fetchLatestResults(completion: @escaping () -> Void)
    func fetchTeams(completion: @escaping () -> Void)
    func addToFav()
    func isStored() -> Bool
    func deleteFromFav()
}


class DetailsLeagueViewModel: DetailLeagueViewModelProtocol {
    var events: [Event] = []
    var latestResults: [Event] = []
    var teams:[Team] = []
    private let networkService: NetworkProtocol
    private let leagueId: String
    private let league:League
    let sportName: Sport
    private let coreDataService:CoreDataProtocol
    weak var delegate: FavoriteUpdateDelegate?
    
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
        var endDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 356, to: Date())!)
        
        var endpoint = "Fixtures&leagueId=\(leagueId)&from=\(startDate)&to=\(endDate)"
        
        if sportName == .tennis{
             endDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 25, to: Date())!)
            
             endpoint = "Fixtures&leagueid=\(leagueId)&from=\(startDate)&to=\(endDate)"
            
        }
        
        networkService.fetchData(sport: sportName, endpoint: endpoint, decodingType: EventsResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventsResponse):
                    self?.events = eventsResponse.result?.reversed() ?? []
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
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let endDate = dateFormatter.string(from: yesterday)
        var startDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -356, to: Date())!)
        
        var endpoint = "Fixtures&leagueId=\(leagueId)&from=\(startDate)&to=\(endDate)"
        if sportName == .tennis{
      
             startDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -5, to: Date())!)
            
             endpoint = "Fixtures&leagueid=\(leagueId)&from=\(startDate)&to=\(endDate)"
            
        }
        networkService.fetchData(sport: sportName, endpoint: endpoint, decodingType: EventsResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventsResponse):
                    self?.latestResults = eventsResponse.result ?? []
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
        coreDataService.addLeague(league: league,sport: sportName)
        delegate?.favoritesDidUpdate()
    }
    func isStored()->Bool{
        return coreDataService.isLeagueSaved(leagueId: Int(leagueId) ?? 0)
    }
    func deleteFromFav(){
        coreDataService.deleteLeague(league: league)
        delegate?.favoritesDidUpdate()
    }
    
}
