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

//struct BusinessCard {
//    let name: String
//    let rating: Double
//    let phone: String?
//    let imageURL: URL?
//    let image: UIImage?
//}

class BusinessCard {
    let name: String
    let rating: Double
    let phone: String?
    let imageURL: URL?
    var image: UIImage?
    
    init(name: String, rating: Double, phone: String?, imageURL: URL?, image: UIImage?) {
        self.name = name
        self.rating = rating
        self.phone = phone
        self.image = image
        self.imageURL = imageURL
    }
    
    public func setImage(_ image: UIImage) {
        self.image = image
    }
}

let imageCache = NSCache<NSString, UIImage>()

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
                        BusinessCard(name: name, rating: rating, phone: phone, imageURL: imageURL, image: nil)
                    )
                }
                completion(cards, nil)
            }
        }
    }
    
    public func downloadImage(url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            self.getDataFromUrl(url: url, completion: { (data, response, error) in
                guard
                    let data = data,
                    let image = UIImage(data: data),
                    error == nil
                    else {
                        return
                }
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image, nil)
            })
        }
    }
    
    public func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}

