//
//  String+Localizable.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns a localized string, using the main bundle
    public var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    enum Localized {
        
        //MARK: - Map Module
        enum Map {
            enum Label {
                static let title = "MAP_LABEL_TITLE".localized
            }
            enum Alert {
                static let title = "MAP_ALERT_TITLE".localized
                static let ok = "MAP_ALERT_OK".localized
            }
        }
        
        //MARK: - LocationManager
        enum Location {
            enum Access {
                static let title = "LOCATION_ACCESS_TITLE".localized
                static let restricted = "LOCATION_ACCESS_RESTRICTED".localized
            }
        }
        
        //MARK: - CityList Module
        enum CityList {
            enum Label {
                static let title = "CITYLIST_LABEL_TITLE".localized
            }
        }
    }
}
