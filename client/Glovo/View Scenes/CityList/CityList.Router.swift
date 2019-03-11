//
//  CityList.Router.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

protocol CityListRouter {
    var cityListPresenter: CityListPresenter? { get set }
    var cityListViewController: CityListViewController? { get set }
    
    func fetchCountriesForPicker()
    func showCard(for city: City)
}

extension Router: CityListRouter {
    
    func fetchCountriesForPicker() {
        let cityList = CityList.Builder.viewController(for: window)
        cityList.presenter?.loadData()
    }

    func showCard(for city: City) {
        let cityInfo = CityInfo.Builder.viewController(with: city)
        if mapViewController == nil {
            mapViewController = window.rootViewController as? MapViewController
        }
        mapViewController?.showWorkingArea(for: city)
        mapViewController?.addCard(with: cityInfo)        
        cityInfo.animateBottomCard()
    }
    
}
