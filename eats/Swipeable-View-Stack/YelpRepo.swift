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
    let phone: String
    let imageURL: URL
}

class YelpRepo {
    static let shared = YelpRepo()
    
    let client = YLPClient.init(apiKey: "WPruHqNCNtovPA8KxPdm9uPeotZ-y9mXjerGJAiL5Reww9KBdImvz5rx-B8Jx0NlTm-AhGoRTa4pU_iOnBToqHCdP8gOaZhgP_2AWDzE3MBdWvjWmr0ErL8hGjWOWnYx")
    
    public func searchTop(coordinate:  CLLocationCoordinate2D) -> [BusinessCard] {
        var cards: [BusinessCard] = []
        
        let lat = coordinate.latitude as Double
        let long = coordinate.longitude as Double
        
        let location = YLPCoordinate(latitude: lat, longitude: long)
        let query = YLPQuery(coordinate: location)
        client.search(with: query) { (response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            if let businesses = response?.businesses {
                for business in businesses {
                    let name = business.name
                    let rating = business.rating
                    
                    guard
                        let phone = business.phone,
                        let imageURL = business.imageURL
                    else {
                        print(error as Any)
                        return
                    }
                    
                    cards.append(
                        BusinessCard(name: name, rating: rating, phone: phone, imageURL: imageURL)
                    )
                }
                print(cards)
            }
        }
        return cards
    }
}

