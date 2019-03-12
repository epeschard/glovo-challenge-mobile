//
//  Map.Router.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation
import UIKit

protocol MapRouter {
    var mapPresenter: MapPresenter? { get set }
    var mapViewController: MapViewController? { get set }
    var cardPresenter: CardPresenter? { get set }
    
    func showMapView(on window: WindowWireframe)
    func show(_ city: City)
    func showManualCityPicker()
}

extension Router: MapRouter {    
    
    func showMapView(on window: WindowWireframe) {
        let mapViewController = Map.Builder.viewController(for: window)
        
        show(mapViewController)
    }
    
    func show(_ city: City) {
        showCard(for: city)
    }
    
    func showManualCityPicker() {
        if let cityList = cityListViewController {
            showBottomCard(with: cityList)
        } else {
            let cityList = CityList.Builder.viewController(for: window)
            showBottomCard(with: cityList)
        }
    }
    
    private func showBottomCard(with view: CardPresentable) {
        mapViewController?.addCard(with: view)
        view.animateBottomCard()
    }
}
