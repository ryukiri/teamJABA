//
//  ViewController.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import YelpAPI
import CoreLocation

class ViewController: UIViewController, SwipeableCardViewDataSource, CLLocationManagerDelegate {

    @IBOutlet private weak var swipeableCardView: SwipeableCardViewContainer!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var noCardsLeftLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let yelpRepo = YelpRepo.shared
    var businesses: [BusinessCard] = []
    var names: [String] = [String]()
    
    var savedSettings : settings = settings(price: "$", distance: 1000.0, openNow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Eats"

        swipeableCardView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.spinner.startAnimating()
        self.spinner.isHidden = false
        self.noCardsLeftLabel.isHidden = true

        if let currentLoc = locationManager.location?.coordinate {
            yelpRepo.searchTop(coordinate: currentLoc, completion: { (response, error) in
                guard
                    let businesses = response
                else {
                    print(error as Any)
                    return
                }
                                
                self.businesses = businesses
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.noCardsLeftLabel.isHidden = false
                    self.swipeableCardView.reloadData()
                }
            })
        }
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("received settings as: price = \(savedSettings.price) distance = \(savedSettings.distance) openNow = \(savedSettings.openNow)")
    }
    
    // MARK: - SwipeableCardViewDataSource
    
    func numberOfCards() -> Int {
        return self.businesses.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let business = self.businesses[index]
        let card = SampleSwipeableCard()
        
        card.viewModel = SampleSwipeableCellViewModel(name: business.name, rating: String(business.rating), imageURL: business.imageURL!)
        
        self.names.append(business.name)
        DataModel.shared.names = self.names
        
        DataModel.shared.locations.append(business.location!)

        DataModel.shared.images.append(business.imageURL!)
        return card
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            let settingsView = segue.destination as! SettingsViewController
            settingsView.savedSettings = self.savedSettings
        }
    }
}

class DataModel {
    static let shared = DataModel()
    var count = 0
    
    var name: String?
    var names: [String] = []
    
    var imageURL: URL?
    var images: [URL] = []

    var location: YLPLocation?
    var locations: [YLPLocation] = []
}

