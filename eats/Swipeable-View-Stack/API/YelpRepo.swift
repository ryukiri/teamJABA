//
//  YelpRepo.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 2/27/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit
import YelpAPI
import CoreLocation

struct BusinessCard {
    let name: String
    let rating: Double
    let phone: String?
    let imageURL: URL?
    let openNow: Bool
//    let distance: Int
//    let priceRange : String
//    let image: UIImage?
}

class YelpRepo {
    static let shared = YelpRepo()
    
    private var businesses : [BusinessCard] = []
    
    let client = YLPClient.init(apiKey: "WPruHqNCNtovPA8KxPdm9uPeotZ-y9mXjerGJAiL5Reww9KBdImvz5rx-B8Jx0NlTm-AhGoRTa4pU_iOnBToqHCdP8gOaZhgP_2AWDzE3MBdWvjWmr0ErL8hGjWOWnYx")
    
    public func searchTop(coordinate:  CLLocationCoordinate2D, completion: @escaping ([BusinessCard]?, Error?) -> Void) {
        authenticate()
        var cards: [BusinessCard] = []

        let lat = coordinate.latitude as Double
        let long = coordinate.longitude as Double

        let location = YLPCoordinate(latitude: lat, longitude: long)
        let query = YLPQuery(coordinate: location)
        
        client.search(with: query) { (response, error) in
            if error != nil {
                completion(nil, error)
                return
            }

            if let businesses = response?.businesses {
                for business in businesses {
                    let name = business.name
                    let rating = business.rating
                    let phone = business.phone
                    let imageURL = business.imageURL
                    let openNow = !business.isClosed
//                    let distance = business.distance

                    cards.append(
                        BusinessCard(name: name, rating: rating, phone: phone, imageURL: imageURL, openNow: openNow)
                    )
                }
                completion(cards, nil)
            }
        }
    }
    
    public func getBusinesses() -> [BusinessCard] {
        return self.businesses
    }
    
    public func filterOpenNow() {
        self.businesses = businesses.filter{$0.openNow == true}
    }
    
    private func authenticate() {
        var authRequest = URLRequest(url: URL(string: "https://api.yelp.com/oauth2/token")!)
        authRequest.setValue("Bearer WPruHqNCNtovPA8KxPdm9uPeotZ-y9mXjerGJAiL5Reww9KBdImvz5rx-B8Jx0NlTm-AhGoRTa4pU_iOnBToqHCdP8gOaZhgP_2AWDzE3MBdWvjWmr0ErL8hGjWOWnYx", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: authRequest) { (data, response, error) -> Void in
            if error != nil {
                NSLog("Problem connecting to internet. Getting data from local file.")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: AnyObject]] {
                    
                    //for each subject in json file..
                    for item in json {
                        let name = item["name"]
                        print(name as? String)
                    }
                } else {
                    NSLog("invalid response")
                }
            } catch let jsonError {
                NSLog("Problem downloading!")
                print(jsonError)
                return
            }
        }
        task.resume()
    }
}

