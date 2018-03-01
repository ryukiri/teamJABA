//
//  YelpRepo.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 2/27/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit
import YelpAPI

struct BusinessCard {
    let name: String
    let rating: Int
    let phone: String
//    let image: UIImage
}

class YelpRepo {
    static let shared = YelpRepo()
    
    private var businesses : [BusinessCard] = []
    
    let client = YLPClient.init(apiKey: "WPruHqNCNtovPA8KxPdm9uPeotZ-y9mXjerGJAiL5Reww9KBdImvz5rx-B8Jx0NlTm-AhGoRTa4pU_iOnBToqHCdP8gOaZhgP_2AWDzE3MBdWvjWmr0ErL8hGjWOWnYx")
    
    init() {
//        let client = yelpRepo.client
        
        let query = YLPQuery(location: "Seattle, WA")
        let sema = DispatchSemaphore(value: 0);

        
        client.search(with: query) { (response, error) in
            if (error != nil) {
                print(error as! String)
                return
            }
            
            if let businesses = response?.businesses {
//                let chinese = businesses.filter { $0.rating > 4 }
//                print("chinese: \(chinese)")
//                
                for business in businesses {
//                    print(business.name)
//                    print(business.rating)
//                    print(business.categories)
                    self.businesses.append(BusinessCard(name: business.name, rating: Int(business.rating), phone: business.phone!))
//                    print("add to businesses")
                }
                sema.signal()
            }
        }
        sema.wait()
//        print("end of init")
    }
    
    public func getBusinesses() -> [BusinessCard] {
        return businesses
    }
    
//    public func searchWithTerm(term: String) -> [BusinessCard] {
//        var cards: [BusinessCard] = []
////        self.client.search(with: <#T##YLPCoordinate#>, term: <#T##String?#>, limit: <#T##UInt#>, offset: <#T##UInt#>, sort: <#T##YLPSortType#>, completionHandler: <#T##YLPSearchCompletionHandler##YLPSearchCompletionHandler##(YLPSearch?, Error?) -> Void#>)
////    }
}

