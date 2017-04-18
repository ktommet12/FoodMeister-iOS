//
//  RestaurantLocation.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/10/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

struct RestaurantLocation{
    var name: String
    var address: String?
    var phoneNum: String?
    var coordLocation: CoordinateLocation
    
    var locationAllergies: [String: Bool]?
    
    var trackedAllergies = ["egg", "wheat", "peanut", "tree_nut", "fish", "shellfish", "soy", "milk"]

    init?(location: [String: Any]){
        guard let name = location["name"] as? String,
            let tempAddress = location["formatted_address"] as? String,
            let coordinateGeo = location["geometry"] as? [String: Any],
            let coordinateJSON = coordinateGeo["location"] as? [String: Any],
            let latitude = coordinateJSON["lat"] as? Double,
            let longitude = coordinateJSON["lng"] as? Double
        else{
            return nil
        }
        self.name = name
        self.coordLocation = CoordinateLocation(lat: latitude, lng: longitude)
        self.address = tempAddress
        
        locationAllergies = [String: Bool]()
        for allergy in trackedAllergies{
            locationAllergies?[allergy] = false
        }
        locationAllergies?["milk"] = true //DEBUG Only
        locationAllergies?["fish"] = true
        locationAllergies?["shellfish"] = true
    }
    func getAllergyImage(name: String)->UIImageView{
        var image: UIImage?
        switch(name){
            case "egg":
                image = UIImage(named: "egg on")
            case "milk":
                image = UIImage(named: "milk on")
            case "wheat":
                image = UIImage(named: "wheat on")
            case "peanut":
                image = UIImage(named: "peanut on")
            case "tree_nut":
                image = UIImage(named: "tree_nut on")
            case "fish":
                image = UIImage(named: "fish on")
            case "shellfish":
                image = UIImage(named: "shellfish on")
            case "soy":
                image = UIImage(named: "soy on")
            default:
                image = nil
        }
        
        let imageView = UIImageView()
        if image != nil{
            imageView.image = image
        }
        
        return imageView
    }
}
struct CoordinateLocation{
    var latitude: Double?
    var longitude: Double?
    
    init(lat: Double, lng: Double){
        latitude = lat
        longitude = lng
    }
}
