//
//  UIButtonDesignable.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/27/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

@IBDesignable class UIButtonDesignable: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = borderRadius
        }
    }

}
