//
//  UIIMageDesignable.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/27/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

@IBDesignable class UIIMageDesignable: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
}
