//
//  DetailsViewController.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 3/1/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    let yelpRepo = YelpRepo.shared
    let dateTime =  DateTimeHelper()
    
    var business: BusinessCard? = nil
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.view.roundCorners()
        self.businessImage.roundCorners()
        
        guard
            let id = business?.id,
            let name = business?.name,
            let image = business?.image,
            let rating = business?.rating,
            let price = business?.price
        else {
            return
        }
        
        self.businessNameLabel.text = name
        self.businessImage.image = image
        self.ratingImage.image = self.getRatingImage(rating)
        self.priceLabel.text = price
        
        // fetch hours
        self.yelpRepo.searchBusinessWithID(id: id) { (response) in
            if let business = response {
                guard
                    let hours = business.hours
                else {
                    return
                }
                let hour = hours[0]
                if let openTimes = hour.open {
                    for open in openTimes {
                        if let openDay = open.day, openDay == self.dateTime.getDayOfWeek(),
                            let start = open.start, let end = open.end {
                            if self.dateTime.format24Hour(time: start) == self.dateTime.format24Hour(time: end) {
                                self.hoursLabel.text = "24 Hours"
                            } else {
                                var range: String = ""
                                range += self.dateTime.format24Hour(time: start)
                                range += " - "
                                range += self.dateTime.format24Hour(time: end)
                                self.hoursLabel.text = range
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getRatingImage(_ rating: Double) -> UIImage {
        switch rating {
        case 1.0:
            return #imageLiteral(resourceName: "yelp_stars_one_regular")
        case 1.5:
            return #imageLiteral(resourceName: "yelp_stars_one_half_regular")
        case 2.0:
            return #imageLiteral(resourceName: "yelp_stars_two_regular")
        case 2.5:
            return #imageLiteral(resourceName: "yelp_stars_two_half_regular")
        case 3.0:
            return #imageLiteral(resourceName: "yelp_stars_three_regular")
        case 3.5:
            return #imageLiteral(resourceName: "yelp_stars_three_half_regular")
        case 4.0:
            return #imageLiteral(resourceName: "yelp_stars_four_regular")
        case 4.5:
            return #imageLiteral(resourceName: "yelp_stars_four_half_regular")
        case 5.0:
            return #imageLiteral(resourceName: "yelp_stars_five_regular")
        default:
            return #imageLiteral(resourceName: "yelp_stars_zero_regular")
        }
    }
    

    @IBAction func onClickPan(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
