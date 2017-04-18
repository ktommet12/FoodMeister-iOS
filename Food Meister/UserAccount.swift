//
//  UserAccount.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/10/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import Foundation

class UserAccount{
    //current max profiles allowed
    let MAX_USER_PROFILES: Int = 4;
    
    var id: Int
    var email: String
    var accountHolderName: String
    var numUserProfiles: Int
    var profileImageURL: URL?
    
    var userProfiles: [UserProfile] = []
    
    init(id: Int = 0, email: String, fullname: String){
        self.id = id;
        self.email = email;
        self.accountHolderName = fullname;
        self.numUserProfiles = 0
        self.userProfiles = loadProfileArray();
    }
    func getAccountHolderName()->String{
        return self.accountHolderName
    }
    func getAccountHolderEmail()->String{
        return self.email
    }
    func getID()->Int{
        return self.id
    }
    func addUserProfile(profile: UserProfile){
        if !self.isAtMaxAllowedProfiles(){
            self.userProfiles.append(profile)
        }
    }
    func setUserProfiles(profiles: [UserProfile]){
        self.userProfiles = profiles
    }
    func changeProfileInfo(){
        //TODO: add functionality to allow for profiles to be modified at any given time
    }
    func getUserProfile(at position: Int)->UserProfile{
        return self.userProfiles[position];
    }
    func getUserProfiles()->[UserProfile]{
        return userProfiles;
    }
    func getUserProfile(by name: String)->UserProfile{
        for profile in userProfiles{
            if(profile.getUsersName() == name){
                return profile;
            }
        }
        return UserProfile();
    }
    func loadProfileArray()->Array<UserProfile>{
        return [UserProfile]()
        //TODO: add functionality to grab the profiles associated with this account from the db and load them into the app
    }
    func toString(){
        print("Name: " + self.accountHolderName)
        print("Email: " + self.email)
        print("Stored Profiles \(self.userProfiles)")
    }
    //whether the user has reached there maximum allowed number of stored profiles
    func isAtMaxAllowedProfiles()->Bool{
        return self.userProfiles.count == self.MAX_USER_PROFILES
    }

}
