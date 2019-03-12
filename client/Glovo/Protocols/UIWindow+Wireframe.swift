//
//  WindowWireframe.swift
//  Glovo
//
//  Created by Eugène Peschard on 12/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit

/// Protocol used to extract UIKit from the Router for acceptance tests
protocol WindowWireframe {
    var rootView: Viewable? { get set }
}

extension UIWindow: WindowWireframe {
    
    var rootView: Viewable? {
        get {
            return rootViewController as? Viewable
        }
        set {
            rootViewController = newValue?.viewController
        }
    }
}

//extension WindowWireframe where Self: UIViewController {
//    var root
//}
