//
//  GoogleMapsHelper.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 3/11/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import GoogleMaps
import GooglePlaces

class GoogleMapsHelper {
    static func createMarker(title: String, coords: CLLocationCoordinate2D, mapView: GMSMapView) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coords.latitude, coords.longitude)
        marker.title = title
        marker.map = mapView
    }
}
