//
//  ViewController.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import CDYelpFusionKit
import CoreLocation

var historyList : [BusinessCard] = []

class ViewController: UIViewController, SwipeableCardViewDataSource, CLLocationManagerDelegate, SwipeableCardViewDelegate, UINavigationControllerDelegate {
    @IBOutlet private weak var swipeableCardView: SwipeableCardViewContainer!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var noCardsLeftLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var yelpRepo = YelpRepo.shared
    var businesses: [BusinessCard] = []
    var userLocation: CLLocationCoordinate2D? = nil
    var selectedCard: Int = -1
    var chosenCard: Int = -1
    
    var updatedSettings: Bool = true
    
    var savedSettings : settings = settings(price: "Any", distance: 10000.0, openNow: true) //default
    

    @IBAction func historyAction(_ sender: Any) {
        let navCont = self.storyboard?.instantiateViewController(withIdentifier: "historyVC") as! HistoryViewController
        self.present(navCont, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Eats"
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "cute"))
//    
//        self.navigationItem.titleView = imageView
        
        
        swipeableCardView.dataSource = self
        swipeableCardView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        print("updated settings to: price = \(String(describing: savedSettings.price)) distance = \(String(describing: savedSettings.distance)) openNow = \(savedSettings.openNow)")
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        if self.updatedSettings {
            print("LOAD")
            self.spinner.startAnimating()
            self.spinner.isHidden = false
            self.noCardsLeftLabel.isHidden = true
            if let currentLoc = locationManager.location?.coordinate {
                self.userLocation = currentLoc
                yelpRepo.searchTop(coordinate: currentLoc, openNow: savedSettings.openNow, completion: { (response, error) in
                    guard
                        var businesses = response
                        else {
                            print(error as Any)
                            return
                    }
                    
                    businesses = businesses.filter{$0.distance <= self.savedSettings.distance}
                    
                    if self.savedSettings.price != "Any" {
                        businesses = businesses.filter{$0.price == self.savedSettings.price}
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
        self.updatedSettings = false
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        self.swipeableCardView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return
        }
        switch segueId {
        case "detailsSegue":
            let detailsView = segue.destination as? DetailsViewController
            detailsView?.business = self.businesses[self.selectedCard]
            detailsView?.userLocation = self.userLocation
        case "settingsSegue":
            let settingsView = segue.destination as? SettingsViewController
            settingsView?.savedSettings = self.savedSettings
            settingsView?.hidesBottomBarWhenPushed = true
        case "chosenSegue":
            let chosenView = segue.destination as? ChoseViewController
            chosenView?.business = self.businesses[self.chosenCard]
        default:
            return
        }
    }
    
    // MARK: - SwipeableCardViewDelegate
    func didSelect(card: SwipeableCardViewCard, atIndex index: Int) {
        self.selectedCard = index
        self.performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
    
    func didEndSwipeRight(card: SwipeableCardViewCard, atIndex index: Int) {
        self.chosenCard = index
        self.performSegue(withIdentifier: "chosenSegue", sender: nil)
    }
    
    // MARK: - SwipeableCardViewDataSource
    
    func numberOfCards() -> Int {
        return self.businesses.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let business = self.businesses[index]
        let card = SampleSwipeableCard()
        
        if let name = business.name, let imageURL = business.imageURL, let rating = business.rating, let image = business.image {
            card.viewModel = SampleSwipeableCellViewModel(name: name, rating: String(format:"%.1f", rating), imageURL: imageURL, image: image)
        }
        return card
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    func didSelectCard(index: Int) {
        self.selectedCard = index
    }
}

