//
//  MockNetworkService.swift
//  SportsTests
//
//  Created by Omar on 14/05/2024.
//

import Foundation
@testable import Sports

class MockNetworkService: NetworkProtocol {
    var shouldReturnError = false
    var mockedData: Decodable?
    
   
    // MARK:  -  Omar code
    func fetchData<T: Decodable>(sport: Sport, endpoint: String, decodingType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnError {
            completionHandler(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        } else {
            if let data = mockedData as? T {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            }
        }
    }
    
    
    
    
 
    // MARK:  - Ghoneim code
    
    func fetchDataWithId<T: Decodable>(sport: Sport, id: Int, endpoint: String, decodingType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnError {
            completionHandler(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        } else {
            if let data = mockedData as? T {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            }
        }
    }
    
    func fetchDataWithLeagueId<T: Decodable>(sport: Sport, id: Int, endpoint: String, decodingType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnError {
            completionHandler(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        } else {
            if let data = mockedData as? T {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            }
        }
    }
    
}

