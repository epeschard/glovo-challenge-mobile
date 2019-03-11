//
//  CityInfo.Interactor.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

protocol CityInfoInteractor {
    var presenter: CityInfoPresenter? { get set }
    
    func fetchInfo(for city: City)
}

extension CityInfo {
    class Interactor: CityInfoInteractor {
        weak var presenter: CityInfoPresenter?
        
        let api = GlovoAPIClient()
        
        func fetchInfo(for city: City) {
            api.fetchCity(with: city.code)
        }
    }
}
