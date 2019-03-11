//
//  CityList.ViewController.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import UIKit
import RealmSwift

protocol CityListViewController: CardPresentable {
    var presenter: CityListPresenter? { get set }
//    var isHidden: Bool { get set }
}

extension CityList {
    class ViewController: UIViewController, CityListViewController {

        var presenter: CityListPresenter?
        var cardPresenter: CardPresenter?
        var isHidden: Bool = false {
            didSet {
                view.isHidden = isHidden
            }
        }

        private var countries = Country.all()
        private var token: NotificationToken?
        
        //MARK: - UI Elements
        
        let handle: UIView = {
            let handle = UIView(frame: .zero)
            handle.backgroundColor = .lightGray
            handle.isUserInteractionEnabled = false
            handle.layer.cornerRadius = 3
            handle.layer.masksToBounds = true
            handle.accessibilityLabel = "handle"
            return handle
        }()
        
        let tableView: UITableView = {
            let table = UITableView(frame: .zero, style: UITableView.Style.plain)
            table.backgroundColor = .clear
            table.alwaysBounceVertical = true
            table.accessibilityLabel = "CityList"
            return table
        }()
        
        //MARK: - Initializers
        
        init() {
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: - Run Loop
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setup()
            layout()
            addGestureRecognizer()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            let realm = RealmProvider.glovo.realm
            token = realm.observe { [weak self] notification, realm in
                self?.tableView.reloadData()
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            token?.invalidate()
        }
        
        //MARK: - Private
        
        private func setup() {
            navigationItem.title = Localized.CityList.Label.title
            setCardAppearance()
            setupTableView()
            addBackgroundBlur()
        }
        
        private func layout() {
            view.addAutolayoutView(tableView)
            view.addAutolayoutView(handle)
            NSLayoutConstraint.activate([
                handle.topAnchor.constraint(equalTo: view.topAnchor, constant: 7),
                handle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                handle.heightAnchor.constraint(equalToConstant: 6),
                handle.widthAnchor.constraint(equalToConstant: 50),
                tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
        
        private func setupTableView() {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .clear
            tableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
        }
        
        private func addBackgroundBlur() {
            view.backgroundColor = .clear
            let blur = UIBlurEffect(style: .extraLight)
            let blurred = UIVisualEffectView(effect: blur)
            view.insertSubview(blurred, at: 0)
            blurred.pinToSuperview()
        }
    }
}

//MARK: - UIGestureRecognizerDelegate

extension CityList.ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == topY && tableView.contentOffset.y == 0 && direction > 0) || (y == midY) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        return false
    }
}

//MARK: - PanRecognizer

extension CityList.ViewController: PanRecognizer {
    
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
                    self?.tableView.isScrollEnabled = true
                }
            })
        }
    }
}

//MARK: - UITableViewDataSource

extension CityList.ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countries[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries[section].cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityList.Cell.reuseID, for: indexPath)
        let city = countries[indexPath.section].cities[indexPath.row]
        cell.textLabel?.text = city.name
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CityList.ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = countries[indexPath.section].cities[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.show(city)
        animateBottomCard()
        isHidden = true
    }
}
