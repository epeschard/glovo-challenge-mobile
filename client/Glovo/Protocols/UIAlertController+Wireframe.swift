//
//  UIAlertController+Wireframe.swift
//  Glovo
//
//  Created by Eugène Peschard on 12/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit

protocol UIAlertControllerWireframe: class {
    
    static var shared: UIApplication { get }
}

extension UIAlertController: UIAlertControllerWireframe {
    static var shared: UIApplication {
        return UIAlertController.shared
    }
}
