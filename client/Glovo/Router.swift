//
//  Router.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

class Router {
    
    var window: WindowWireframe
    init(with window: WindowWireframe) {
        self.window = window
    }
    
    func start() {
        showStartView()
    }
    
    private func showStartView() {
        fetchCountriesForPicker()
        showMapView(on: window)
    }
    
    func show(_ view: Viewable) {
        window.rootView = view
    }
    
    //MARK: - MapRouter
    var mapPresenter: MapPresenter?
    var mapViewController: MapViewController?
    
    //MARK: - CityListRouter
    var cityListPresenter: CityListPresenter?
    var cityListViewController: CityListViewController?
    var cardPresenter: CardPresenter?
}
