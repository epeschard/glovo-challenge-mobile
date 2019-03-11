//
//  Country.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import RealmSwift

@objcMembers public class Country: Object {
    dynamic var code: String = ""
    dynamic var name: String = ""
    
    let cities = LinkingObjects(fromType: City.self,
                                property: City.Property.country.rawValue)//.sorted(byKeyPath: "name")
    
    override public static func primaryKey() -> String? {
        return Country.Property.code.rawValue
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    enum Property: String {
        case code, name
    }
}

extension Country: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case code, name
    }
}

extension Country {
    static func all(in realm: Realm = RealmProvider.glovo.realm) -> Results<Country> {
        return realm.objects(Country.self)
            .sorted(byKeyPath: Country.Property.name.rawValue)
    }
    
    @discardableResult
    static func add(country: Country, in realm: Realm = RealmProvider.glovo.realm) -> Country {
        try! realm.write {
            realm.add(country)
        }
        return country
    }
    
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
    }
}
