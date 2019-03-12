//
//  CardPresentable.swift
//  Glovo
//
//  Created by Eugène Peschard on 09/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit

protocol CardPresentable: UIGestureRecognizerDelegate, PanRecognizer {
    
    var cardPresenter: CardPresenter? { get set }

    var topY: CGFloat { get }
    var midY: CGFloat { get }
    var lowY: CGFloat { get }
    
    var isHidden: Bool { get set }
    
    func addGestureRecognizer()
    func setCardAppearance()
    func animateBottomCard()
}

@objc protocol PanRecognizer {
    func panGesture(_ recognizer: UIPanGestureRecognizer)
}

extension CardPresentable where Self: UIViewController {
    
    var midY: CGFloat {
        return UIScreen.main.bounds.height - 200
    }
    
    var topY: CGFloat {
        return 100.0
    }
    
    var lowY: CGFloat {
        return UIScreen.main.bounds.height - 50
    }
    
    func addGestureRecognizer() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func animateBottomCard() {
        if view.traitCollection.horizontalSizeClass == .compact {
            UIView.animate(withDuration: 0.6, animations: { [weak self] in
                guard let frame = self?.view.frame, let y = self?.midY else { return }
                self?.view.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height)
            })
        }
    }
    
    func setCardAppearance() {
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 1, alpha: 0.8)
    }
}
