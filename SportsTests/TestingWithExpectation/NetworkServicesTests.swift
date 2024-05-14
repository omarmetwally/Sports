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

    
    
   
    // MARK:  - Ghoneim Code 
    
}
