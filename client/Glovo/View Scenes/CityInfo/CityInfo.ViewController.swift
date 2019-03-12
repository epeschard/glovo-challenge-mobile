//
//  CityInfo.ViewController.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit
import RealmSwift

protocol CityInfoViewController: CardPresentable {
    var presenter: CityInfoPresenter? { get set }
}

extension CityInfo {
    class ViewController: UIViewController, CityInfoViewController {
        
        var presenter: CityInfoPresenter?
        var cardPresenter: CardPresenter?
        var isHidden: Bool = false {
            didSet {
                view.isHidden = isHidden
            }
        }
        
        private var city: City
        private var token: NotificationToken?
        
        private enum Constants {
            static let margin: CGFloat = 3
            static let spacing: CGFloat = 8
        }
        
        //MARK: - UI Elements
        
        let handle: UIView = {
            let handle = UIView(frame: .zero)
            handle.backgroundColor = .lightGray
            handle.isUserInteractionEnabled = false
            handle.layer.cornerRadius = 3
            handle.layer.masksToBounds = true
            handle.accessibilityLabel = "Handle"
            return handle
        }()
        
        let name: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .left
            label.textColor = .white
            label.font = UIFont.preferredFont(forTextStyle: .title1)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            label.accessibilityLabel = "Name"
            return label
        }()
        
        let country: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .left
            label.textColor = .lightGray
            label.font = UIFont.preferredFont(forTextStyle: .headline)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            label.accessibilityLabel = "Country"
            return label
        }()
        
        let currency: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .right
            label.textColor = .lightGray
            label.font = UIFont.preferredFont(forTextStyle: .body)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            label.accessibilityLabel = "Currency"
            return label
        }()
        
        let enabled: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .left
            label.textColor = .lightGray
            label.font = UIFont.preferredFont(forTextStyle: .body)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            label.accessibilityLabel = "Enabled"
            return label
        }()
        
        let timeZone: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .left
            label.textColor = .lightGray
            label.font = UIFont.preferredFont(forTextStyle: .body)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            label.accessibilityLabel = "Time Zone"
            return label
        }()
        
        let languageCode: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .left
            label.textColor = .lightGray
            label.font = UIFont.preferredFont(forTextStyle: .body)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            label.accessibilityLabel = "Language Code"
            return label
        }()
        
        let stackViewV: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = Constants.spacing
            stackView.accessibilityLabel = "Content View"
            return stackView
        }()
        
        let stackViewH: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = Constants.spacing
            stackView.accessibilityLabel = "Country stack"
            return stackView
        }()
        
        private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.alwaysBounceVertical = true
            scrollView.accessibilityLabel = "Scroll View"
            return scrollView
        }()
        
        //MARK: - Initializers
        
        init(with city: City) {
            self.city = city
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: - Run Loop
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setCardAppearance()
            layout()
            setup()
            presenter?.fetchInfo(for: city)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            updateUI(with: city)
            // Use realm notifications to reactively update the UI
            token = city.observe { [weak self] changes in
                if let city = self?.city {
                    self?.updateUI(with: city)
                }
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            token?.invalidate()
        }
        
        //MARK: - Private
        
        private func layout() {
            view.addAutolayoutView(handle)
            view.addSubview(scrollView)
            scrollView.pinToSuperview()
            scrollView.addAutolayoutView(stackViewV)
            let inset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            stackViewV.pinToSuperview(withEdges: inset)
            
            stackViewV.addArrangedSubview(name)
            stackViewV.addArrangedSubview(stackViewH)
            
            stackViewH.addArrangedSubview(country)
            stackViewH.addArrangedSubview(currency)
            
            stackViewV.addArrangedSubview(enabled)
            stackViewV.addArrangedSubview(timeZone)
            stackViewV.addArrangedSubview(languageCode)
            
            NSLayoutConstraint.activate([
                handle.topAnchor.constraint(equalTo: view.topAnchor, constant: 7),
                handle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                handle.heightAnchor.constraint(equalToConstant: 6),
                handle.widthAnchor.constraint(equalToConstant: 50),
                stackViewV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                stackViewV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                ])
        }
        
        private func setup() {
            view.backgroundColor = .clear
            addBackgroundBlur()
        }
        
        private func updateUI(with city: City) {
            name.text = city.name
            country.text = city.country?.name
            currency.text = city.currency
            timeZone.text = city.time_zone
            if city.enabled.value ?? false {
                enabled.isHidden = true
            } else {
                enabled.isHidden = false
                enabled.text = Localized.CityInfo.Label.disabled
            }
            languageCode.text = city.language_code
        }
        
        private func addBackgroundBlur() {
            view.backgroundColor = .clear
            let blur = UIBlurEffect(style: .dark)
            let blurred = UIVisualEffectView(effect: blur)
            view.insertSubview(blurred, at: 0)
            blurred.pinToSuperview()
        }
    }
}

//MARK: - PanRecognizer

extension CityInfo.ViewController: PanRecognizer {
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        let y = view.frame.minY
        if (y + translation.y >= topY) && (y + translation.y <= midY) {
            view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - topY) / -velocity.y) : Double((midY - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.midY, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.topY, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.scrollView.isScrollEnabled = true
                }
            })
        }
    }
}
