//
//  ReusableID.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseID: String { get }
}

extension ReuseIdentifiable {
    static var reuseID: String {
        return String(describing: Self.self)
    }
}
