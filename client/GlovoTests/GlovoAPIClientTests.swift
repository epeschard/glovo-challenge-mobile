//
//  GlovoAPIClientTests.swift
//  GlovoTests
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import XCTest
@testable import Glovo

class GlovoAPIClientTests: XCTestCase {
    
    var apiClient: GlovoAPIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = GlovoAPIClient()
    }
    
    func testFetchCountries() {
        let expect = expectation(description: "Fetch Completes")
        
        apiClient.fetchCities()
//        apiClient.fetchCountries { (response, error) in
//            XCTAssert(response != nil)
//            expect.fulfill()
//        }
        wait(for: [expect], timeout: 3)
    }
//    
//    func testFetchCities() {
//        let expect = expectation(description: "Fetch Completes")
//        
//        apiClient.fetchCities { (response, error) in
//            XCTAssert(response != nil)
//            expect.fulfill()
//        }
//        wait(for: [expect], timeout: 3)
//    }
//    
//    func testFetchCity() {
//        let expect = expectation(description: "Fetch Completes")
//        
//        apiClient.fetchCity { (response, error) in
//            XCTAssert(response != nil)
//            expect.fulfill()
//        }
//        wait(for: [expect], timeout: 3)
//    }
    
}
