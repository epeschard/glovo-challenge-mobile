//
//  UIApplication+Wireframe.swift
//  Glovo
//
//  Created by Eugène Peschard on 12/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit

protocol UIApplicationWireframe: class {
    static var openSettingsURLString: String { get }
    static var shared: UIApplication { get }
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: UIApplicationWireframe {
    static var openSettingsURLString: String {
        return UIApplication.openSettingsURLString
    }
}
