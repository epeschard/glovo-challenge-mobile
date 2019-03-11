//
//  Router.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation
import UIKit

class Router {
    
    let window: UIWindow
    init(with window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showStartView()
    }
    
    private func showStartView() {
        showRedView()
    }
    
    func show(_ view: UIViewController) {
        window.rootViewController = view
    }
}

extension Router {
    func showRedView() {
        let redController = UIViewController()
        redController.view.backgroundColor = .red
        show(redController)
    }
}
