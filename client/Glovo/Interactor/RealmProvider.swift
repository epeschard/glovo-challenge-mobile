//
//  RealmProvider.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation
import RealmSwift

/// Provides access the the app's realms
struct RealmProvider {
    let configuration: Realm.Configuration
    var realm: Realm {
        return try! Realm(configuration: configuration)
    }
    
    internal init(config: Realm.Configuration) {
        configuration = config
    }
    
    private static let glovoConfig = Realm.Configuration(
        fileURL: try! Path.inDocuments(Constants.Glovo.realm),
        schemaVersion: 1,
        deleteRealmIfMigrationNeeded: true,
        objectTypes: [Country.self, City.self])
    
    public static var glovo: RealmProvider = {
        return RealmProvider(config: glovoConfig)
    }()
}
