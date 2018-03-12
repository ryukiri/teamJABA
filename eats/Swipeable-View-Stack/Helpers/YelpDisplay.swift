//
//  YelpDisplay.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 3/12/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import Foundation
import UIKit

class YelpDisplays {
    static func getRatingImage(_ rating: Double) -> UIImage {
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
}
