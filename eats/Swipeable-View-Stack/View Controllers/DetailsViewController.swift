//
//  DetailsViewController.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 3/1/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

enum Location {
    case start
    case end
}

class DetailsViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    let yelpRepo = YelpRepo.shared
    let dateTime =  DateTimeHelper()
    
    var business: BusinessCard? = nil
    var userLocation: CLLocationCoordinate2D? = nil
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.hexStringToUIColor("F9F9F9")
        self.view.roundCorners()
        self.detailsView.roundCorners()
        self.mapView.roundCorners()
        self.businessImage.contentMode = .scaleAspectFill
        
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
        self.ratingImage.image = YelpDisplays.getRatingImage(rating)
        self.priceLabel.text = price
        
        // fetch hours
        self.yelpRepo.searchBusinessWithID(id: id) { (response) in
            if let business = response {
                guard
                    let hours = business.hours,
                    let location = business.location,
                    let address = location.displayAddress,
                    let coords = business.coordinates,
                    let lat = coords.latitude,
                    let long = coords.longitude,
                    let userCoords = self.userLocation
                else {
                    return
                }
                // set hours label
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
                
                let businessCoords: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16)
                
                self.mapView.camera = camera
                self.mapView.delegate = self
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.mapView.settings.zoomGestures = true
                
                self.drawPath(start: userCoords, end: businessCoords)
                GoogleMapsHelper.createMarker(title: "START", coords: userCoords, mapView: self.mapView)
                GoogleMapsHelper.createMarker(title: "END", coords: businessCoords, mapView: self.mapView)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func drawPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let origin = "\(start.latitude),\(start.longitude)"
        let destination = "\(end.latitude),\(end.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking"
        
        Alamofire.request(url).responseJSON { (response) in
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                // print route using Polyline
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = Color.hexStringToUIColor("1890f9")
                    polyline.map = self.mapView
                }
            } catch {
                return
            }
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
