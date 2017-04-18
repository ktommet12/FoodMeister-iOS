//
//  CustomSwitch.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/8/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

class CustomSwitch: UISwitch{
    @IBInspectable var OffTint: UIColor?{
        didSet{
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
