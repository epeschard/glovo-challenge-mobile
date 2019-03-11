//
//  APIClientTests.swift
//  GlovoTests
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import XCTest
//@testable import Glovo

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
        
        apiClient.fetchIPAddress { (ip, error) in
            guard let ip = ip else {
                XCTFail()
                exp.fulfill()
                return
            }
            XCTAssert(ip.origin.count > 0)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    
//    func testParseIPResponse() throws {
//        let json =
//            """
//{
//  "origin": "80.34.92.76"
//}
//"""
//                .data(using: .utf8)!
//        guard let response: HTTPBin.Responses.IP = try? apiClient.parseResponse(data: json) else {
//            XCTFail("Response threw error")
//            return
//        }
//        XCTAssert(response.origin == "80.34.92.76")
//    }
    
    
}
