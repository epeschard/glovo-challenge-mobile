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
    
    func showMapView(on window: UIWindow)
    func presentAlert(
        from view: UIViewController,
        with title: String,
        and message: String,
        using style: UIAlertController.Style,
        and actions: [UIAlertAction])
    func show(_ city: City)
    func showManualCityPicker()
}

extension Router: MapRouter {
    
    func showMapView(on window: UIWindow) {
        let mapViewController = Map.Builder.viewController(for: window)
        
        show(mapViewController)
    }
    
    func presentAlert(from view: UIViewController, with title: String, and message: String, using style: UIAlertController.Style, and actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        _ = actions.map { alert.addAction($0) }
        view.present(alert, animated: true) {
            [weak self] in
            self?.showManualCityPicker()
        }
    }
    
    @objc private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            fatalError("Failed to get url from UIApplication.openSettingsURLString")
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
