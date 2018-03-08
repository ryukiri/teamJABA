//
//  ViewController.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, SwipeableCardViewDataSource, CLLocationManagerDelegate, SwipeableCardViewDelegate {
    @IBOutlet private weak var swipeableCardView: SwipeableCardViewContainer!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var noCardsLeftLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let yelpRepo = YelpRepo.shared
    var businesses: [BusinessCard] = []
    var selectedCard: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            yelpRepo.searchTop(coordinate: currentLoc, completion: { (response, error) in
                guard
                    let businesses = response
                else {
                    print(error as Any)
                    return
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
    
    @IBAction func refreshAction(_ sender: UIButton) {
        self.swipeableCardView.reloadData()
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings will go here", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction)in
            print("Ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didSelect(card: SwipeableCardViewCard, atIndex index: Int) {
        self.selectedCard = index
        self.performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsView = segue.destination as? DetailsViewController
        detailsView?.business = self.businesses[self.selectedCard]
    }

    
    // MARK: - SwipeableCardViewDataSource
    
    func numberOfCards() -> Int {
        return self.businesses.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let business = self.businesses[index]
        let card = SampleSwipeableCard()
        card.viewModel = SampleSwipeableCellViewModel(name: business.name, rating: String(describing: business.rating), imageURL: business.imageURL, image: business.image)
        
        return card
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    func didSelectCard(index: Int) {
        print(index)
    }
}

