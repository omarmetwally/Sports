//
//  FavoriteLeaguesViewModel.swift
//  Sports
//
//  Created by Omar on 12/05/2024.
//




protocol FavoriteUpdateDelegate: AnyObject {
    func favoritesDidUpdate()
}



protocol LeaguesDisplayable {
    var leagues: [League] { get }
    var sport: Sport? {get}
    func fetchData(completion: @escaping () -> Void)
}


class FavoriteLeaguesViewModel: LeaguesDisplayable {
    var sport: Sport?
    
    private var coreDataService: CoreDataServices
    var leagues: [League] = []
    
    init(coreDataService: CoreDataServices) {
        self.coreDataService = coreDataService
        
    }
    
    func fetchData(completion: @escaping () -> Void) {
        print("Favorite fetchData")
        self.leagues = coreDataService.retriveAllLeagues()
        if let firstLeagueSport = self.leagues.first?.sport {
            self.sport = firstLeagueSport 
        }
        completion()
    }
    func delete(league: League, completion: @escaping () -> Void) {
        coreDataService.deleteLeague(league: league)
        completion()
    }

}
