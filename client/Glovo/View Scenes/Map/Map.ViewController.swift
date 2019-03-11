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

protocol MapViewController: CardPresenter {
    var presenter: MapPresenter? { get set }
    var mapView: GMSMapView! { get set }
    
    func animateMap(to coordinate: CLLocationCoordinate2D, zoom level: Float)
    func addMapMarker(with title: String, and snippet: String, at center: CLLocationCoordinate2D?)
    func showWorkingArea(for city: City)
    func showCityMarkers()
}

extension Map {
    class ViewController: UIViewController, MapViewController {
        
        var presenter: MapPresenter?
        var mapView: GMSMapView!
        
        enum ZoomLevel: Int {
            case monoCity
            case multiCity
        }
        var zoomLevel: ZoomLevel = .monoCity
        
        private var cities = City.all()
        private var token: NotificationToken?
        
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
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            let realm = RealmProvider.glovo.realm
            token = realm.observe { [weak self] notification, realm in
                guard let self = self else { return }
                
                if let point = self.mapView.myLocation?.coordinate,
                    let city = self.presenter?.getCity(at: point) {
                    self.presenter?.show(city)
                    self.showWorkingArea(for: city)
                }
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            presenter?.checkLocationServices()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            token?.invalidate()
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
    }
}

//MARK: - GMSMapViewDelegate

extension Map.ViewController: GMSMapViewDelegate {
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        //TODO: Pending implementation
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if mapView.camera.zoom <= 10.0 && zoomLevel != .multiCity {
            zoomLevel = .multiCity
            showCityMarkers()
        } else if mapView.camera.zoom > 10.0 && zoomLevel != .monoCity {
            zoomLevel = .monoCity
            if let city = presenter?.getCity(at: position.target) {
                presenter?.show(city)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //TODO: Pending implementation
        return true
    }
    
}
