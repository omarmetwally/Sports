//
//  NetworkServicesTests.swift
//  SportsTests
//
//  Created by Omar on 14/05/2024.
//

import XCTest
@testable import Sports

class NetworkServicesTests: XCTestCase {
    var networkService: NetworkServices!

    override func setUp() {
        super.setUp()
        networkService = NetworkServices()
    }

    override func tearDown() {
        networkService = nil
        super.tearDown()
    }

   // MARK:  - Omar code
    func testFetchDataWithSuccess() {
        let expectation = self.expectation(description: "Fetch league data success")

        networkService.fetchData(sport: .football, endpoint: "Leagues", decodingType: LeagueResponse.self) { result in
            switch result {
            case .success(let leagueResponse):
                XCTAssertGreaterThan(leagueResponse.result.count, 0, "Should have at least one league")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error \(error)")
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
    func testFetchDataWithInvalidEndpoint() {
        let expectation = self.expectation(description: "Fetch with invalid endpoint")

        networkService.fetchData(sport: .football, endpoint: "omar", decodingType: LeagueResponse.self) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure but got success.")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
    func testFetchDataWithIDSucess(){
        let expectation = expectation(description: "waiting for team data")
        
        networkService.fetchDataWithId(sport: Sport.football ,id: 97, endpoint: "Teams", decodingType: TeamResponse.self) { result in
                switch result {
                case .success(let teamResponse):
                    XCTAssertEqual(teamResponse.result.count, 1, "team details failed")
                    expectation.fulfill()
                case .failure(let error):
                    print("Error fetching teams: \(error.localizedDescription)")
                    expectation.fulfill()
                }
            }
        
        waitForExpectations(timeout: 10)
    }
    func testFetchDataWithIDFaliure(){
        let expectation = expectation(description: "waiting for team data")
        
        networkService.fetchDataWithId(sport: Sport.football ,id: -3, endpoint: "Teams", decodingType: TeamResponse.self) { result in
                switch result {
                case .success(_):
                    XCTFail("Expected failure but got success.")
                case .failure(let error):
                    XCTAssertNotNil(error, "Error should not be nil")
                    expectation.fulfill()
                }
            }
        
        waitForExpectations(timeout: 10)
    }
    func testFetchDataWithLeagueIDSucess(){
        let expectation = expectation(description: "waiting for team data")
        
        networkService.fetchDataWithLeagueId(sport: Sport.football ,id: 10, endpoint: "Teams", decodingType: TeamResponse.self) { result in
                switch result {
                case .success(let teamResponse):
                    XCTAssertGreaterThan(teamResponse.result.count, 0, "Should have at least one Team")
                    expectation.fulfill()
                case .failure(let error):
                    print("Error fetching teams: \(error.localizedDescription)")
                    expectation.fulfill()
                }
            }
        
        waitForExpectations(timeout: 10)
    }
    func testFetchDataWithLeagueIDFaliure(){
        let expectation = expectation(description: "waiting for team data")
        
        networkService.fetchDataWithLeagueId(sport: Sport.football ,id: -3, endpoint: "Teams", decodingType: TeamResponse.self) { result in
                switch result {
                case .success(_):
                    XCTFail("Expected failure but got success.")
                case .failure(let error):
                    XCTAssertNotNil(error, "Error should not be nil")
                    expectation.fulfill()
                }
            }
        
        waitForExpectations(timeout: 10)
    }


    
    
   
    // MARK:  - Ghoneim Code 
    
}
