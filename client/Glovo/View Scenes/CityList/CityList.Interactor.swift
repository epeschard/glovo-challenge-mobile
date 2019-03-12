//
//  CityList.Interactor.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

protocol CityListInteractor {
    var presenter: CityListPresenter? { get set }
    
    func fetchCountries()
}

extension CityList {
    class Interactor: CityListInteractor {
        weak var presenter: CityListPresenter?
        
        let api = GlovoAPIClient()
        
        func fetchCountries() {
            api.fetchCountries()
            api.fetchCities()
        }
    }
}
