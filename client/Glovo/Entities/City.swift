//
//  City.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import RealmSwift
import GoogleMaps

@objcMembers class City: Object {
    dynamic var code: String = ""
    dynamic var name: String = ""
    dynamic var currency: String?
    dynamic var country_code: String = ""
    dynamic var country: Country?
    var enabled = RealmOptional<Bool>()
    dynamic var time_zone: String?
    var busy = RealmOptional<Bool>()
    dynamic var language_code: String?
    // Realm list storing the array of polylines
    var working_area = List<String>()
    
    
    private let northEastLat = RealmOptional<Double>()
    private let northEastLon = RealmOptional<Double>()
    private let southWestLat = RealmOptional<Double>()
    private let southWestLon = RealmOptional<Double>()
    private let centerLat = RealmOptional<Double>()
    private let centerLon = RealmOptional<Double>()
    
    var bounds: GMSCoordinateBounds? {
        get {
            guard
                let northEastLat = northEastLat.value,
                let northEastLon = northEastLon.value,
                let southWestLat = southWestLat.value,
                let southWestLon = southWestLon.value
                else { return nil }
            let northEast = CLLocationCoordinate2DMake(northEastLat, northEastLon)
            let southWest = CLLocationCoordinate2DMake(southWestLat, southWestLon)
            return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        }
        set {
            guard let bounds = newValue else {
                northEastLat.value = nil
                northEastLon.value = nil
                southWestLat.value = nil
                southWestLon.value = nil
                return
            }
            northEastLat.value = bounds.northEast.latitude
            northEastLon.value = bounds.northEast.longitude
            southWestLat.value = bounds.southWest.latitude
            southWestLon.value = bounds.southWest.longitude
        }
    }
    
    var center: CLLocationCoordinate2D? {
        get {
            guard
                let centerLat = centerLat.value,
                let centerLon = centerLon.value
                else { return nil }
            return CLLocationCoordinate2DMake(centerLat, centerLon)
        }
        set {
            guard let center = newValue else {
                centerLat.value = nil
                centerLon.value = nil
                return
            }
            centerLat.value = center.latitude
            centerLon.value = center.longitude
        }
    }
    
    override public static func primaryKey() -> String? {
        return City.Property.code.rawValue
    }
    
    enum Property: String {
        case code, name, currency, country_code, country, enabled, time_zone, busy, language_code, working_area, northEastLat, northEastLon, southWestLat, southWestLon
    }
}

extension City {
    static func all(in realm: Realm = RealmProvider.glovo.realm) -> Results<City> {
        return realm.objects(City.self)
            .sorted(byKeyPath: City.Property.country_code.rawValue)
            .sorted(byKeyPath: City.Property.name.rawValue)
    }
    
    @discardableResult
    static func add(city: City, in realm: Realm = RealmProvider.glovo.realm) -> City {
        try! realm.write {
            realm.add(city)
        }
        return city
    }
    
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
    }
}
