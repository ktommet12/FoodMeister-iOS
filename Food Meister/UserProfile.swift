//
//  UserProfile.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/10/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import Foundation


class UserProfile{
    var userName = "null";              //name of the user associated with the profile
    var parentAccountEmail = "";        //email of the account the profile is attached to
    var birthdate = "null"              //users birthdate
    var gender = UserGender.Default;    //users gender
    
    let currentlyTrackedAllergies = ["Milk", "Peanut", "Egg", "Soy", "Wheat", "Fish", "Tree Nuts", "Shellfish"]
    var profileAllergies = [String:Bool]()
    
    init(name: String, email: String, birthdate: String, gender: UserGender){
        self.userName = name;
        self.parentAccountEmail = email;
        self.birthdate = birthdate;
        self.gender = gender;
        self.initAllergyDict()
    }
    init(name: String, email: String){
        self.userName = name;
        self.birthdate = "";
        self.gender = .Default;
        self.parentAccountEmail = email;
        self.initAllergyDict()
    }
    init(){
        self.initAllergyDict()
    }
    func getUsersName()->String{
        return self.userName;
    }
    func getBirthdate()->String{
        return self.birthdate
    }
    func getAllergies()->[String:Bool]{
        return self.profileAllergies
    }
    func toString(){
        print("Name: " + self.userName)
        print("Email: " + self.parentAccountEmail)
        print("Birthdate: " + self.birthdate)
        print("Gender: " + self.gender.rawValue)
        print("Profile Allergies: \(self.profileAllergies)")
    }
    //initializes the allergy dictionary with false default values for each allergy
    func initAllergyDict(){
        for allergy in self.currentlyTrackedAllergies{
            self.profileAllergies[allergy] = false
        }
    }
    //toggles the allergy, if it is true it then switches to false, and vice versa
    func toggleAllergy(name: String){
        if(self.profileAllergies[name] == true){
            self.profileAllergies[name] = false
        }else{
            self.profileAllergies[name] = true
        }
    }
}
