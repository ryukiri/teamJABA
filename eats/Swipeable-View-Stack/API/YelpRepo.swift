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
//    let image: UIImage?
}

class YelpRepo {
    static let shared = YelpRepo()
    
    private var businesses : [BusinessCard] = []
    
    let client = YLPClient.init(apiKey: "WPruHqNCNtovPA8KxPdm9uPeotZ-y9mXjerGJAiL5Reww9KBdImvz5rx-B8Jx0NlTm-AhGoRTa4pU_iOnBToqHCdP8gOaZhgP_2AWDzE3MBdWvjWmr0ErL8hGjWOWnYx")
    
    public func searchTop(coordinate:  CLLocationCoordinate2D, completion: @escaping ([BusinessCard]?, Error?) -> Void) {
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

                    cards.append(
                        BusinessCard(name: name, rating: rating, phone: phone, imageURL: imageURL)
                    )
                }
                completion(cards, nil)
            }
        }
    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    public func getBusinesses() -> [BusinessCard] {
        return self.businesses
    }
}

