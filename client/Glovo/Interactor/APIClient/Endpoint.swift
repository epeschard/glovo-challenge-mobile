//
//  Endpoint.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

public protocol Endpoint {
    
    /// The path for the request
    var path: String { get }
    
    /// The HTTPMethod for the request
    var method: HTTPMethod { get }
    
    /// Optional parameters for the request
    var parameters: [String : Any]? { get }
    
    /// How the parameters should be encoded
    var parameterEncoding: HTTPParameterEncoding { get }
    
    /// The HTTP headers to be sent
    var httpHeaderFields: [String : String]? { get }
}

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, OPTIONS, HEAD, PATCH, TRACE, CONNECT
}

public enum HTTPParameterEncoding {
    case url
    case json
}

extension Endpoint {
    public var method: HTTPMethod {
        return .GET
    }
    
    public var parameters: [String : Any]? {
        return nil
    }
    
    public var parameterEncoding: HTTPParameterEncoding {
        return .url
    }
    
    public var httpHeaderFields: [String : String]? {
        return nil
    }
}
