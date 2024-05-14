//
//  NetworkServicesTests.swift
//  SportsTests
//
//  Created by Omar on 14/05/2024.
//

import XCTest
@testable import Sports
class NetworkServiceMockTests: XCTestCase {
    
    
    
    // MARK:  - Omar code
    func testFetchLeagueDataWithMockedSuccess() {
        let mockNetworkService = MockNetworkService()
        let league = League(leagueKey: 1, leagueName: "Premier League", countryKey: 44, countryName: "England", leagueLogo: nil, countryLogo: nil, sport: .football)
        let expectedData = LeagueResponse(success: 1, result: [league])
        mockNetworkService.mockedData = expectedData
        
        mockNetworkService.fetchData(sport: .football, endpoint: "Leagues", decodingType: LeagueResponse.self) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.result.count, expectedData.result.count)
                XCTAssertEqual(data.result.first?.leagueName, expectedData.result.first?.leagueName)
            case .failure:
                XCTFail("Expected success but got failure.")
            }
        }
    }
    func testFetchLeagueDataWithMockedFailure() {
            let mockNetworkService = MockNetworkService()
            mockNetworkService.shouldReturnError = true

            mockNetworkService.fetchData(sport: .football, endpoint: "Leagues", decodingType: LeagueResponse.self) { result in
                switch result {
                case .success(_):
                    XCTFail("Expected failure but got success.")
                case .failure(let error):
                    XCTAssertNotNil(error, "Expected an error but error was nil")
                }
            }
        }
    
    
 
    // MARK:  - Ghoneim code
    
    
}
