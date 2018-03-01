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

    let locationManager = CLLocationManager()
    let yelpRepo = YelpRepo.shared
    var businesses: [BusinessCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        swipeableCardView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

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
                    self.swipeableCardView.reloadData()
                }
            })
        }
    }

    @IBAction func settingsAction(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings will go here", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction)in
            print("Ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - SwipeableCardViewDataSource
    
    func numberOfCards() -> Int {
        return self.businesses.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let business = self.businesses[index]
        let card = SampleSwipeableCard()
        
        card.viewModel = SampleSwipeableCellViewModel(name: business.name, rating: String(business.rating))
        
        return card
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
}

