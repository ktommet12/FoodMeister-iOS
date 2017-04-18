//
//  GoogleMapsController.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/12/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class GoogleMapsController: UIViewController, DBWorkerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var userCurrentLocation: CLLocationCoordinate2D!
    
    @IBOutlet weak var showMapSettings: UIBarButtonItem!
    var dbWorker = DBWorker()
    var userAccount: UserAccount?
    var fmMap = FMMap()
    var searchResults: [RestaurantLocation]?
    var locationMananger = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("GoogleMaps ViewDidLoad Called")
        
        if self.revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        searchResults = [RestaurantLocation]()
        
        //showMapSettings.tex
        
        dbWorker.delegate = self
        googleMap.delegate = self
        locationMananger.delegate = self
        locationMananger.desiredAccuracy = kCLLocationAccuracyBest
        locationMananger.requestWhenInUseAuthorization()
        
        
        locationMananger.requestLocation()
        DBWorker.isTaskInProgress = false
        
    }
    //DBWorker Task has Finished
    func didFinishTask(returnedJSON: [String : Any]?, wasASuccess: Bool) {
        if wasASuccess{
            //print(returnedJSON)
            if returnedJSON != nil{
                let googlePlacesResults = returnedJSON?["results"] as! NSArray
                for place in googlePlacesResults{
                    let newRestaurant = RestaurantLocation(location: place as! [String : Any]);
                    if searchResults != nil{
                        searchResults?.append(newRestaurant!)
                    }
                    if newRestaurant != nil{
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake((newRestaurant?.coordLocation.latitude)!,  (newRestaurant?.coordLocation.longitude)!)
                        marker.title = newRestaurant?.name
                        marker.snippet = newRestaurant?.address
                        marker.icon = UIImage(named: "CustomMapMarker")
                        marker.map = googleMap
                    }
                }
            }
        }
    }
    func loadNearbyPlaces(location: CLLocationCoordinate2D){
        if DBWorker.isTaskInProgress == false{
            dbWorker.getLocalSearchResults(location: location)
        }
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        var restaurant: RestaurantLocation?
        
        if searchResults != nil{
            for place in searchResults!{
                if marker.title == place.name{
                    restaurant = place
                }
            }
        }

        let infoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self.view, options: nil)?[0] as! CustomInfoWindow
        if restaurant != nil{
            infoWindow.restaurantName.text = restaurant?.name
            infoWindow.restaurantAddress.text = restaurant?.address
            
            let trackedAllergyStrings = restaurant?.trackedAllergies
            let restaurantAllergies = restaurant?.locationAllergies

            for allergy in trackedAllergyStrings!{
                if restaurantAllergies?[allergy] == true{
                    var imageView = restaurant?.getAllergyImage(name: allergy)
                    infoWindow.locationAllergyStackView.addArrangedSubview(imageView!)
                }
            }
        }
        
        infoWindow.layer.cornerRadius = 15
        return infoWindow
    }
}


extension GoogleMapsController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            googleMap.isMyLocationEnabled = true
            print("LocationManager has been authorized")

        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print("locationManager has returned location data")
            
            googleMap.settings.myLocationButton = true
            googleMap.settings.scrollGestures = true
            googleMap.settings.rotateGestures = false
            
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let camera = GMSCameraPosition.camera(withTarget: myLocation, zoom: 15)
            
            let marker = GMSMarker()
            marker.position = camera.target
            marker.snippet = "My Location"
            marker.icon = UIImage(named: "myLocationPin")
            marker.map = googleMap
            
            googleMap.animate(to: camera)
            googleMap.settings.rotateGestures = false
            
            if DBWorker.isTaskInProgress == false{
                DispatchQueue.global(qos: .background).async {
                    self.loadNearbyPlaces(location: myLocation)
                    DBWorker.isTaskInProgress = true;
                }
            }
            
            //locationMananger.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Destination: \(segue.destination)")
    }
}
