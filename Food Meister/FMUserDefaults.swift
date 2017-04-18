//
//  FmUserDefaults.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/4/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import Foundation

class FMUserDefaults{
    var defaults = UserDefaults.standard;
    init(){}
    func addUserDefault(forKey: String, data: String){
        self.defaults.set(data , forKey: forKey);
        self.defaults.synchronize()
    }
    func getUserDefault(forKey: String)->Any?{
        self.defaults.synchronize()
        return self.defaults.object(forKey: forKey);
    }
    func deleteUserDefault(forKey: String){
        self.defaults.removeObject(forKey: forKey)
        self.defaults.synchronize()
    }
}
