//
//  UIColor+Ext.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Nameclass for corporate colors
    enum Glovo {
        public static var yellow: UIColor {
            return .goldenTainoi
        }
        public static var green: UIColor {
            return .mountainMeadow
        }
    }
    
    /// Glovo's coorporate yellow
    public static var goldenTainoi: UIColor {
        return UIColor(red:1.00, green:0.76, blue:0.32, alpha:1.00)
    }
    
    /// Glovo's coorporate green
    public static var mountainMeadow: UIColor {
        return UIColor(red:0.20, green:0.73, blue:0.61, alpha:1.00)
    }
    
}
