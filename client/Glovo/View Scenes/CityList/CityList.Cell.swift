//
//  CityList.Cell.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit
import RealmSwift

extension CityList {
    @objc (CityListCell)
    class Cell: UITableViewCell, ReuseIdentifiable {
        private var item: City?
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: String(describing: Cell.self))
            selectionStyle = .default
            backgroundColor = .clear
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with item: City) {
            self.item = item
            self.textLabel?.text = item.name
            self.detailTextLabel?.text = item.country?.name
        }
        
    }
}
