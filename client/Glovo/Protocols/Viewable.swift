//
//  Viewable.swift
//  Glovo
//
//  Created by Eugène Peschard on 12/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit

protocol Viewable: class {
//    func present(alert: UIViewController, animated: )
}

extension UIViewController: Viewable { }

extension Viewable {
    var viewController: UIViewController? {
        return self as? UIViewController
    }
}
