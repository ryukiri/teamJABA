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
}

class YelpRepo {
    static let shared = YelpRepo()
    
    private var businesses : [BusinessCard] = []
    
    let client = YLPClient.init(apiKey: "WPruHqNCNtovPA8KxPdm9uPeotZ-y9mXjerGJAiL5Reww9KBdImvz5rx-B8Jx0NlTm-AhGoRTa4pU_iOnBToqHCdP8gOaZhgP_2AWDzE3MBdWvjWmr0ErL8hGjWOWnYx")
    
//        init() {
//            print("INIT")
//        //        let client = yelpRepo.client
//
//                let query = YLPQuery(location: "Seattle, WA")
//                let sema = DispatchSemaphore(value: 0);
//
//
//                    client.search(with: query) { (response, error) in
//                        if (error != nil) {
//                            print(error as! String)
//                            return
//                        }
//
//                        if let businesses = response?.businesses {
//            //                let chinese = businesses.filter { $0.rating > 4 }
//            //                print("chinese: \(chinese)")
//            //
//                            for business in businesses {
//            //                    print(business.name)
//            //                    print(business.rating)
//            //                    print(business.categories)
//                                self.businesses.append(BusinessCard(name: business.name, rating: business.rating, phone: business.phone!))
//            //                    print("add to businesses")
//                            }
//                            sema.signal()
//                        }
//                    }
//                    sema.wait()
//            //        print("end of init")
//            }
    
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
    
    public func getBusinesses() -> [BusinessCard] {
        return self.businesses
    }
}

