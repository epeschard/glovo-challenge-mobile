//
//  APIClientTests.swift
//  GlovoTests
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import XCTest

class HTTPBinAPITests: XCTestCase {
    func testIPEndpoint() {
        let getIP = HTTPBin.API.ip
        XCTAssert(getIP.path == "/ip")
        XCTAssert(getIP.method == .GET)
    }
}

class APIClientTests: XCTestCase {
    
    var apiClient: HTTPBinAPIClient!
    
    override func setUp() {
        super.setUp()
        
        apiClient = HTTPBinAPIClient(environment: HTTPBin.Hosts.production)
    }
    
    func testGET() {
        let exp = expectation(description: "Fetch completes")
        
        apiClient.fetchIPAddress { (data, error) in
            guard let data = data else {
                XCTFail()
                exp.fulfill()
                return
            }
            let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
            if let json = jsonObject as? [String: String], let ip = json["origin"] {
                XCTAssert(ip == "93.176.154.124, 93.176.154.124")
            } else {
                XCTFail()
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
}
