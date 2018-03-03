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
    var yelpRepo = YelpRepo.shared
    var businesses: [BusinessCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
    
    // MARK: - SwipeableCardViewDataSource
    
    func numberOfCards() -> Int {
        return self.businesses.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let business = self.businesses[index]
        let card = SampleSwipeableCard()
        
        card.viewModel = SampleSwipeableCellViewModel(name: business.name, rating: String(business.rating), imageURL: business.imageURL!)
        
        return card
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.yelpRepo = self.yelpRepo
    }
}

