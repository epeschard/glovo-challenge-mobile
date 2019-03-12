//
//  CardPresenter.swift
//  Glovo
//
//  Created by Eugène Peschard on 09/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit

protocol CardPresenter: class {
    func addCard(with card: CardPresentable)
}

extension CardPresenter where Self: UIViewController {
    
    func addCard(with card: CardPresentable) {

        if let viewController = card as? UIViewController {
            if let index = self.children.firstIndex(of: viewController) {
                let cardVC = self.children[index]
                cardVC.willMove(toParent: nil)
                cardVC.view.removeFromSuperview()
                cardVC.removeFromParent()
            }
            self.addChild(viewController)
            self.view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            
            let height = view.frame.height
            let width  = view.frame.width
            if view.traitCollection.horizontalSizeClass == .compact {
                viewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
            } else {
                let height = view.frame.height - CGFloat(integerLiteral: 32)
                viewController.view.frame = CGRect(x: 16, y: 16, width: view.frame.width/3, height: height)
            }
        }
    }
    
}
