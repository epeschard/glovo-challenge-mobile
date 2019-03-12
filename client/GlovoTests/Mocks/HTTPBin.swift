//
//  HTTPBin.swift
//  GlovoTests
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import XCTest
import Foundation
@testable import Glovo

class HTTPBinAPIClient: APIClient {
    
    func fetchIPAddress(handler: @escaping(Data?, Swift.Error?) -> Void) {
        let request: Request<HTTPBin.Responses.IP> = requestForEndpoint(HTTPBin.API.ip)
        self.performData(request) { (ip, error) in
            handler(ip, error)
        }
    }
}

enum HTTPBin {
    enum Hosts: Environment {
        case production
        case development
        
        var baseURL: URL {
            switch self {
            case .production:
                return URL(string: "https://httpbin.org")!
            case .development:
                return URL(string: "https://dev.httpbin.org")!
            }
        }
    }
    
    enum API: Endpoint {
        case ip
        case orderPizza
        
        var path: String {
            switch self {
            case .orderPizza:
                return "/forms/post"
            case .ip:
                return "/ip"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .orderPizza:
                return .POST
            default:
                return .GET
            }
        }
    }
}

//MARK: Responses

extension HTTPBin {
    enum Responses {
        struct IP: Decodable {
            let origin: String
        }
    }
}
