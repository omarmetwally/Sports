//
//  TeamViewModel.swift
//  Sports
//
//  Created by user242921 on 5/11/24.
//

import Foundation


class TeamViewModel{
 
    var network:NetworkProtocol
  //  var bindNewsToViewController : (()->()) = {}
    var sport:Sport
    var id:Int
    
    var team : Team?{didSet{
        players = team?.players ?? []
    }}
    var players : [Player] = []
    
init(network:NetworkProtocol,sport:Sport,id:Int){
        self.network = network
        self.sport = sport
        self.id=id
    }
    func fetchData(completion: @escaping () -> Void) {
        network.fetchDataWithId(sport: sport,id: id, endpoint: "Teams", decodingType: TeamResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teamResponse):
                    self?.team = teamResponse.result[0]
                    completion()
                case .failure(let error):
                    print("Error fetching leagues: \(error.localizedDescription)")
                    completion()
                }
            }
        }
    }
   func getTeam()->Team?{
       return team
    }
    func getPlayerAtIndex(i:Int)->Player{
        return players[i]
    }
    func getPlayerCount()->Int{
        return players.count
    }

}
