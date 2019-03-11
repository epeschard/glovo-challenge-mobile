//
//  CityInfo.Builder.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

enum CityInfo {
    class Builder {
        
        static func viewController(with city: City) -> ViewController {
            let viewController = ViewController(with: city)
            let interactor = Interactor()
            let presenter = Presenter()
            let router = Router()
            
            viewController.presenter = presenter
            
            interactor.presenter = presenter
            
            presenter.interactor = interactor
            presenter.view = viewController
            presenter.router = router
            
            router.presenter = presenter
            router.viewController = viewController
            
            return viewController
        }
    }
}
