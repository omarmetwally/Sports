//
//  CoreDataServices.swift
//  Sports
//
//  Created by user242921 on 5/11/24.
//

import Foundation
import CoreData

protocol CoreDataProtocol {
    func addLeague(league:League)
    func isLeagueSaved(leagueId:Int)->Bool
    func deleteLeague(league:League)
    func retriveAllLeagues()
    func deleteAllLeagues()
    
}
class CoreDataServices:CoreDataProtocol{
    var managedContext : NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    func isLeagueSaved(leagueId: Int)->Bool {
        let predicate = NSPredicate(format: "leagueKey == %@", NSNumber(integerLiteral: leagueId))

    
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LeagueCD")

        fetchRequest.predicate = predicate
        do{
              let results = try managedContext.fetch(fetchRequest)
            if(results.isEmpty){
                print("empty")
                return false
            }else{
                print("has")
                return true
            }
        }catch let error{
            print(error)
            return false
        }
            }
    
    func deleteAllLeagues() {
        //delete all because (primary key البيه معندوش)
    }
    
    func addLeague(league: League) {

        let entity = NSEntityDescription.entity(forEntityName: "LeagueCD", in: managedContext)!
        let leagueObj = NSManagedObject(entity: entity, insertInto: managedContext)
        
        leagueObj.setValue(league.leagueKey, forKey: "leagueKey")
        leagueObj.setValue(league.leagueName, forKey: "leagueName")
        leagueObj.setValue(league.leagueLogo?.absoluteString, forKey: "leagueLogo")
       
        do{
            try managedContext.save()
            print("saved")
            
        }catch let error{
            print(error)
        }
    }
    
    func deleteLeague(league: League) {
        //add delete
    }
    
    func retriveAllLeagues() {
        //add retrive
    }
    
    
}
