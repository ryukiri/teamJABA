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

class ViewController: UIViewController, SwipeableCardViewDataSource, CLLocationManagerDelegate, SwipeableCardViewDelegate {
    @IBOutlet private weak var swipeableCardView: SwipeableCardViewContainer!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var noCardsLeftLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var yelpRepo = YelpRepo.shared
    var businesses: [BusinessCard] = []
    var selectedCard: Int = -1
    
    var savedSettings : settings? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOADED VIEW")
        
        if savedSettings == nil {
            savedSettings = settings(price: "$$", distance: 1000.0, openNow: true) //default settings
        } else {
            print("I got saved settings!")
        }
        
        self.title = "Eats"
        
        swipeableCardView.dataSource = self
        swipeableCardView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.spinner.startAnimating()
        self.spinner.isHidden = false
        self.noCardsLeftLabel.isHidden = true
        
        if let currentLoc = locationManager.location?.coordinate {
            yelpRepo.searchTop(coordinate: currentLoc, openNow: (savedSettings?.openNow)!, completion: { (response, error) in
                guard
                    var businesses = response
                else {
                    print(error as Any)
                    return
                }
                
                //filter businesses
                businesses = businesses.filter{$0.distance <= (self.savedSettings?.distance)!}
                //filter by price
                if self.savedSettings?.price != "Any" {
                    businesses = businesses.filter {$0.price == self.savedSettings?.price}
                }

                self.businesses = businesses

                // download images
                for business in self.businesses {
                    if let imageURL = business.imageURL {
                        self.yelpRepo.downloadImage(url: imageURL, completion: { (image, error) in
                            guard
                                let image = image,
                                error == nil
                                else {
                                    return
                            }
                            DispatchQueue.main.async {
                                business.setImage(image)
                                self.spinner.stopAnimating()
                                self.spinner.isHidden = true
                                self.noCardsLeftLabel.isHidden = false
                                self.swipeableCardView.reloadData()
                            }
                        })
                    }
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("settings are: price = \(savedSettings?.price) distance = \(savedSettings?.distance) openNow = \(savedSettings?.openNow)")
        
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        self.swipeableCardView.reloadData()
    }
    
    func didSelect(card: SwipeableCardViewCard, atIndex index: Int) {
        self.selectedCard = index
        self.performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details segue" {
            let detailsView = segue.destination as? DetailsViewController
            detailsView?.business = self.businesses[self.selectedCard]
        }
        if segue.identifier == "settings segue" {
            let settingsView = segue.destination as? SettingsViewController
            settingsView?.savedSettings = savedSettings
        }
    }

    
    // MARK: - SwipeableCardViewDataSource
    
    func numberOfCards() -> Int {
        return self.businesses.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let business = self.businesses[index]
        let card = SampleSwipeableCard()
        card.viewModel = SampleSwipeableCellViewModel(name: business.name, rating: String(business.rating), imageURL: business.imageURL, image: business.image)
        
        return card
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    func didSelectCard(index: Int) {
        print(index)
    }
}

