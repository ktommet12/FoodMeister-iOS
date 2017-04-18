//
//  AddProfileView.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 4/5/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

@IBDesignable class AddProfileView: UIView {

    @IBInspectable var borderRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = borderRadius
        }
    }
}
