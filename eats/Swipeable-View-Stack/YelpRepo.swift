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
    let image: UIImage
}

class YelpRepo {
    static let shared = YelpRepo()
    
    let client = YLPClient.init(apiKey: "WPruHqNCNtovPA8KxPdm9uPeotZ-y9mXjerGJAiL5Reww9KBdImvz5rx-B8Jx0NlTm-AhGoRTa4pU_iOnBToqHCdP8gOaZhgP_2AWDzE3MBdWvjWmr0ErL8hGjWOWnYx")
    
    
    public func searchWithTerm(term: String) -> [BusinessCard] {
        var cards: [BusinessCard] = []
//        self.client.search(with: <#T##YLPCoordinate#>, term: <#T##String?#>, limit: <#T##UInt#>, offset: <#T##UInt#>, sort: <#T##YLPSortType#>, completionHandler: <#T##YLPSearchCompletionHandler##YLPSearchCompletionHandler##(YLPSearch?, Error?) -> Void#>)
//    }
}

