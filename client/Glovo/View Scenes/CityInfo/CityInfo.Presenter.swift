//
//  CityInfo.Presenter.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

protocol CityInfoPresenter: class {
    
    var router: CityInfoRouter? { get set }
    var interactor: CityInfoInteractor? { get set }
    var view: CityInfoViewController? { get set }
    
    func fetchInfo(for city: City)
}

extension CityInfo {
    class Presenter: NSObject, CityInfoPresenter {
        
        var router: CityInfoRouter?
        var interactor: CityInfoInteractor?
        weak var view: CityInfoViewController?
        
        func fetchInfo(for city: City) {
            interactor?.fetchInfo(for: city)
        }
    }
}
