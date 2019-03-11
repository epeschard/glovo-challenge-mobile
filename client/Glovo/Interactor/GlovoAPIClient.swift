//
//  GlovoAPIClient.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation
import RealmSwift
import GoogleMaps

public class GlovoAPIClient: APIClient {
    public init() {
        super.init(environment: Glovo.Hosts.production)
    }
    
    public func fetchCountries() {
        let request: Request<[Country]> = requestForEndpoint(Glovo.API.countries)
        self.performData(request) { (data, error) in
            guard let data = data else {
                return
            }
            let realm = RealmProvider.glovo.realm
            try! realm.write {
                let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
                if let jsonArray = jsonObject as? [Any] {
                    for json in jsonArray {
                        _ = realm.create(Country.self, value: json, update: true)
                    }
                }
            }
        }
    }
    
    public func fetchCities() {
        let request: Request<[City]> = requestForEndpoint(Glovo.API.cities)
        self.performData(request) { (data, error) in
            guard let data = data else {
                return
            }
            let realm = RealmProvider.glovo.realm
            try! realm.write {
                let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
                if let jsonArray = jsonObject as? [Any] {
                    for json in jsonArray {
                        let city = realm.create(City.self, value: json, update: true)
                        if let json = json as? [String: Any], let countryCode = json[City.Property.country_code.rawValue] {
                            let country = realm.object(ofType: Country.self, forPrimaryKey: countryCode)
                            city.country = country
                            if let workingArea = json[City.Property.working_area.rawValue] as? [String], let bounds = self.getBounds(for: workingArea) {
                                city.bounds = bounds
                                city.center = self.getCenter(of: bounds)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func fetchCity(with code: String) {
        let request: Request<City> = requestForEndpoint(Glovo.API.city(code))
        self.performData(request) { (data, error) in
            guard let data = data else {
                return
            }
            let realm = RealmProvider.glovo.realm
            do {
                try realm.write {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    _ = realm.create(City.self, value: json, update: true)
                }
            } catch { debugPrint(error) }
        }
    }
    
    private func getBounds(for encodedPolylines: [String]) -> GMSCoordinateBounds? {
        if let first = encodedPolylines.first, let firstPath = GMSPath(fromEncodedPath: first) {
            let firstBounds = GMSCoordinateBounds(path: firstPath)
            
            let combinedBounds = encodedPolylines.reduce(firstBounds, {
                previousBounds, nextPoly in
                if let nextPath = GMSPath(fromEncodedPath: nextPoly) {
                    return previousBounds.includingPath(nextPath)
                } else {
                    return previousBounds
                }
            })
            return combinedBounds
        }
        return nil
    }
    
    private func getCenter(of bounds: GMSCoordinateBounds) -> CLLocationCoordinate2D {
        let lat = bounds.southWest.latitude + (bounds.northEast.latitude - bounds.southWest.latitude) / 2
        let lon = bounds.southWest.longitude + (bounds.northEast.longitude - bounds.southWest.longitude) / 2
        return CLLocationCoordinate2DMake(lat, lon)
    }
}

public enum Glovo {
    enum Hosts: Environment {
        case production
        
        var baseURL: URL {
            switch self {
            case .production:
                var components = URLComponents()
                components.scheme = "http"
//                components.host = "localhost"
                components.host = "192.168.1.139"
                components.port = 3000
                
                return components.url!
            }
        }
    }
    
    enum API: Endpoint {
        case countries
        case cities
        case city(String)
        
        var path: String {
            switch self {
            case .countries:
                return "/api/countries/"
            case .cities:
                return "/api/cities/"
            case .city(let code):
                return "/api/cities/\(code)"
            }
        }
        
    }
    
}
