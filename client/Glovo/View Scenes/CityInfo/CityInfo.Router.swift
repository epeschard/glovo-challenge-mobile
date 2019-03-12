//
//  CityInfo.Router.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

protocol CityInfoRouter {
    var presenter: CityInfoPresenter? { get set }
    
}

extension CityInfo {
    class Router: CityInfoRouter {
        
        weak var presenter: CityInfoPresenter?
        weak var viewController: CityInfoViewController?
    }
}
