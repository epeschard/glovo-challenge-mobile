//
//  Map.ViewController.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

enum ZoomLevel: Int {
    case monoCity
    case multiCity
}

protocol MapViewController: CardPresenter {
    var presenter: MapPresenter? { get set }
    var mapView: GMSMapView! { get set }
    var ignoreZoomChanges: Bool { get set }
    
    func animateMap(to coordinate: CLLocationCoordinate2D, zoom level: Float)
    func addMapMarker(with title: String, and snippet: String, at center: CLLocationCoordinate2D?)
    func showWorkingArea(for city: City)
    func showCityMarkers()
    func presentAlert(from view: UIViewController, with title: String, and message: String, using style: UIAlertController.Style, and actions: [UIAlertAction])
}

extension Map {
    class ViewController: UIViewController, MapViewController {
        
        var presenter: MapPresenter?
        var mapView: GMSMapView!
        
        var zoomLevel: ZoomLevel = .monoCity
        var ignoreZoomChanges: Bool = false
        
        private var cities = City.all()
        
        //MARK: - Initializers
        
        init() {
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: - Run Loop
        
        override func loadView() {
            super.loadView()
            setupMapView()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            presenter?.checkLocationServices()
        }
        
        //MARK: - Private - loadView
        
        private func setupMapView() {
            mapView = GMSMapView(frame: .zero)
            mapView.delegate = self
            mapView.isMyLocationEnabled = true
            view = mapView
        }
        
        //MARK: - MapViewController
        
        func animateMap(to coordinate: CLLocationCoordinate2D, zoom level: Float) {
            let position = GMSCameraPosition.camera(withTarget: coordinate, zoom: level)
            mapView?.animate(to: position)
        }
        
        func addMapMarker(with title: String, and snippet: String, at center: CLLocationCoordinate2D?) {
            guard let center = center else { return }
            let marker = GMSMarker(position: center)
            marker.snippet = snippet
            marker.title = title
            marker.map = mapView
            marker.icon = #imageLiteral(resourceName: "Glovo_shape.pdf")
        }
        
        func showWorkingArea(for city: City) {
            if let cityArea = city.bounds {
                let zoomUpdate = GMSCameraUpdate.fit(cityArea, withPadding: 8.0)
                mapView.animate(with: zoomUpdate)
                showPolygon(for: city)
            }
        }
        
        private func showPolygon(for city: City) {
            mapView.clear()
            for workingArea in city.working_area {
                guard let path = GMSPath(fromEncodedPath: workingArea) else { continue }
                let polygon = GMSPolygon(path: path)
                polygon.fillColor = UIColor(white: 0.3, alpha: 0.4)
                polygon.isTappable = false
                polygon.map = mapView
            }
        }
        
        func showCityMarkers() {
            for city in self.cities {
                self.addMapMarker(with: city.name, and: city.code, at: city.center)
            }
        }
        
        func presentAlert(from view: UIViewController, with title: String, and message: String, using style: UIAlertController.Style, and actions: [UIAlertAction]) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            _ = actions.map { alert.addAction($0) }
            view.present(alert, animated: true) {
                [weak self] in
                self?.presenter?.router?.showManualCityPicker()
            }
        }
        
        @objc private func openSettings() {
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                fatalError("Failed to get url from UIApplication.openSettingsURLString")
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//MARK: - GMSMapViewDelegate

extension Map.ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if ignoreZoomChanges {
            ignoreZoomChanges = false
            return
        }
        if mapView.camera.zoom <= 10.0 && zoomLevel != .multiCity {
            mapView.clear()
            zoomLevel = .multiCity
            showCityMarkers()
        } else if mapView.camera.zoom > 10.0 && zoomLevel != .monoCity {
            mapView.clear()
            zoomLevel = .monoCity
            if let city = presenter?.getCity(at: position.target) {
                presenter?.show(city)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let realm = RealmProvider.glovo.realm
        let cityCode = marker.snippet
        if let city = realm.object(ofType: City.self, forPrimaryKey: cityCode) {
            presenter?.show(city)
        }
        ignoreZoomChanges = true
        return true
    }
    
}
