//
//  ChoseViewController.swift
//  Swipeable-View-Stack
//
//  Created by Austin Quach on 3/2/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit
import MapKit

class ChoseViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let yelpRepo = YelpRepo.shared
    
    var business: BusinessCard? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let id = business?.id,
            let name = business?.name,
            let location = business?.location,
            let address = location.displayAddress,
            let image = business?.image
        else {
            return
        }
        var addressString: String = ""
        for line in address {
            addressString += "\(line)\n"
        }
        historyList.insert(business!, at: 0)
        UserDefaults.standard.set(historyList, forKey: "history")
        nameLabel.text = name
        addressLabel.text = addressString
        self.image.image = image
        

        // fetch coordinates
        self.yelpRepo.searchBusinessWithID(id: id) { (response) in
            if let business = response {
                guard
                    let coords = business.coordinates,
                    let lat = coords.latitude,
                    let long = coords.longitude
                else {
                    return
                }
                let initialLocation = CLLocation(latitude: lat, longitude: long)
                self.centerMapOnLocation(location: initialLocation)
                
                // show artwork on map
                let artwork = MapDetails(title: name,
                                         locationName: name,
                                         discipline: "Restaurant",
                                         coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                self.mapView.addAnnotation(artwork)
            }
        }
    }

    let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    @IBAction func navigateButton(_ sender: Any) {
        let id = business?.id
        
        self.yelpRepo.searchBusinessWithID(id: id!) { (response) in
            if let business = response {
                guard
                    let coords = business.coordinates,
                    let lat = coords.latitude,
                    let long = coords.longitude
                    else {
                        return
                }
                
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
                {
                    UIApplication.shared.openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(Float((lat))),\(Float((long)))&directionsmode=driving")! as URL)
                } else
                {
                    NSLog("Can't use com.google.maps://");
                }
            }
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let text = "Some message"
        
        if UIApplication.shared.canOpenURL(URL(string:"sms:")!) {
            UIApplication.shared.open(URL(string:"sms:")!, options: [:], completionHandler: nil)
        }
    }
    
}
