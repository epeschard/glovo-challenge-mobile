//
//  Realm+Tests.swift
//  Glovo
//
//  Created by Eugène Peschard on 12/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import RealmSwift

extension RealmProvider {
    func copyForTesting() -> RealmProvider {
        var conf = self.configuration
        conf.inMemoryIdentifier = UUID().uuidString
        conf.readOnly = false
        return RealmProvider(config: conf)
    }
}

extension Realm {
    func addForTesting(objects: [Object]) {
        try! write {
            add(objects)
        }
    }
}
