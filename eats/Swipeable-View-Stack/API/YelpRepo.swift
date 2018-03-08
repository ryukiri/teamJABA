//
//  YelpRepo.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 2/27/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit
import CoreLocation
import YelpAPI
import CDYelpFusionKit
import Alamofire
import AlamofireObjectMapper

class BusinessCard {
    let id: String?
    let name: String?
    let rating: Double?
    let phone: String?
    let imageURL: URL?
    let location: CDYelpLocation?
    var image: UIImage?
    var price: String?
    
    
    init(id: String, name: String, rating: Double, phone: String?, imageURL: URL?, image: UIImage?, location: CDYelpLocation?, price: String?) {
        self.id = id
        self.name = name
        self.rating = rating
        self.phone = phone
        self.image = image
        self.imageURL = imageURL
        self.location = location
        self.price = price
    }
    
    public func setImage(_ image: UIImage) {
        self.image = image
    }
}

let imageCache = NSCache<NSString, UIImage>()

class YelpRepo {
    static let shared = YelpRepo()
    
    private var businesses : [BusinessCard] = []
    private let apiKey: String? = "WPruHqNCNtovPA8KxPdm9uPeotZ-y9mXjerGJAiL5Reww9KBdImvz5rx-B8Jx0NlTm-AhGoRTa4pU_iOnBToqHCdP8gOaZhgP_2AWDzE3MBdWvjWmr0ErL8hGjWOWnYx";
    private lazy var yelpAPIClient = CDYelpAPIClient(apiKey: apiKey)
    private lazy var manager: Alamofire.SessionManager = {
        if let apiKey = self.apiKey,
            apiKey != "" {
            var headers = Alamofire.SessionManager.defaultHTTPHeaders
            headers["Authorization"] = "Bearer \(apiKey)"
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = headers
            return Alamofire.SessionManager(configuration: configuration)
        } else {
            return Alamofire.SessionManager()
        }
    }()
    
    public func searchTop(coordinate:  CLLocationCoordinate2D, openNow: Bool, completion: @escaping ([BusinessCard]?, Error?) -> Void) {
        var cards: [BusinessCard] = []

        let lat = coordinate.latitude as Double
        let long = coordinate.longitude as Double
        
        yelpAPIClient.searchBusinesses(byTerm: nil, location: nil, latitude: lat, longitude: long, radius: 10000, categories: [.food], locale: .english_unitedStates, limit: 10, offset: 0, sortBy: .rating, priceTiers: [.oneDollarSign, .twoDollarSigns, .threeDollarSigns, .fourDollarSigns], openNow: openNow, openAt: nil, attributes: nil) { (response) in
                if let businesses = response?.businesses {
                    for business in businesses {
                        guard
                            let id = business.id,
                            let name = business.name,
                            let rating = business.rating,
                            let phone = business.phone,
                            let imageURL = business.imageUrl,
                            let location = business.location,
                            let price = business.price
                        else {
                            return
                        }
                        
                        cards.append(
                            BusinessCard(id: id, name: name, rating: rating, phone: phone, imageURL: imageURL, image: nil, location: location, price: price)
                        )
                    }
                    completion(cards, nil)
                }
        }
    }
    
    public func searchBusinessWithID(id: String, completion: @escaping (CDYelpBusiness?) -> ()) {
        if let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)") {
            self.manager.request(url).responseObject(completionHandler: { (response: DataResponse<CDYelpBusiness>) in
                switch response.result {
                case .success(let searchResponse):
                    completion(searchResponse)
                case .failure(let error):
                    print("ERROR: " + String(describing: error))
                    completion(nil)
                }
            })
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

