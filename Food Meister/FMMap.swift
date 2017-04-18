//
//  FMMap.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/5/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import CoreLocation

struct FMMap{
    //failback location in case of locationManager failure to get current Location
    let DEFAULT_LOCATION = CLLocationCoordinate2D(latitude: 33.376958, longitude: -111.975861)
    let DEFAULT_SEARCH_RADIUS = 15000
    let DEFAULT_SEARCH_TYPE = "restaurant"
    var userLocation: CLLocationCoordinate2D?
    var searchRadius = 15000
    var searchType = "restaurant"
    
    let googleURLS = GoogleUrls()
    
    
    
    //var locationManager = CLLocationManager()
    private let dbWorker = DBWorker()
    
    init(){}
    
    func getNearbyPlacesUrl()->String{
        var googlePlacesUrl = ""
        return googlePlacesUrl
        
    }
    
    
    

}
struct GoogleUrls{
    let GooglePlacesNearbySearch = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let GooglePlacesTextSearch = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
}
