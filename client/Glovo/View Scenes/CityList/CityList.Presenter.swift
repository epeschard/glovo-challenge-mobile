//
//  CityList.Presenter.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

protocol CityListPresenter: class {
    
    var router: CityListRouter? { get set }
    var interactor: CityListInteractor? { get set }
    var view: CityListViewController? { get set }
    
    func loadData()
    func show(_ city: City)
}

extension CityList {
    class Presenter: NSObject, CityListPresenter {
        
        var router: CityListRouter?
        var interactor: CityListInteractor?
        weak var view: CityListViewController?
        
        var mapPresenter: MapPresenter?
        var cardPresenter: CardPresenter?
        
        func loadData() {
            interactor?.fetchCountries()
        }
        
        func show(_ city: City) {
            router?.showCard(for: city)
        }
        
    }
}
