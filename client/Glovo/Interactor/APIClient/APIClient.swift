//
//  APIClient.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

public struct Signature {
    let name: String
    let value: String
}

public class APIClient {
    
    let environment: Environment
    let signature: Signature?
    let urlSession: URLSession
    let jsonDecoder = JSONDecoder()
    
    public init(environment: Environment, signature: Signature? = nil) {
        self.environment = environment
        self.signature = signature
        self.urlSession = URLSession(configuration: .default)
    }
    
    public func performData<T>(_ request: Request<T>, handler: @escaping (Data?, Swift.Error?) -> Void) {
        URLRequest.createURLRequest(request: request) { (urlRequest, error) in
            guard error == nil, let urlRequest = urlRequest else {
                handler(nil, error)
                return
            }
            
            let task = self.urlSession.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    handler(nil, error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                    (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 399) else {
                        handler(nil, Error.httpError)
                        return
                }
                
                guard let data = data else {
                    handler(nil, Error.unknown)
                    return
                }
                
                handler(data, nil)
            }
            task.resume()
        }
    }
    
    func requestForEndpoint<T>(_ endpoint: Endpoint) -> Request<T> {
        return Request<T>(
            endpoint: endpoint,
            environment: environment,
            signature: signature
        )
    }
    
    public enum Error: Swift.Error {
        case malformedURL
        case malformedParameters
        case malformedJSONResponse
        case httpError
        case unknown
    }
    
}

public extension URLRequest {
    static func createURLRequest<T>(request: Request<T>, handler: @escaping (URLRequest?, Swift.Error?) -> Void) {
        do {
            let request = try URLRequest.init(fromRequest: request)
            handler(request, nil)
        } catch let error {
            handler(nil, error)
        }
    }
    
    init<T>(fromRequest request: Request<T>) throws {
        let endpoint = request.endpoint
        let environment = request.environment
        guard let url = URL(string: endpoint.path, relativeTo: environment.baseURL) else {
            throw APIClient.Error.malformedURL
        }
        
        self.init(url: url)
        
        httpMethod = endpoint.method.rawValue
        allHTTPHeaderFields = endpoint.httpHeaderFields
        if let signature = request.signature {
            setValue(
                signature.value,
                forHTTPHeaderField: signature.name
            )
        }
        
        //TODO: account for the parameter encoding.
        if let parameters = endpoint.parameters {
            do {
                let requestData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                httpBody = requestData
                setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw APIClient.Error.malformedParameters
            }
        }
    }
}
