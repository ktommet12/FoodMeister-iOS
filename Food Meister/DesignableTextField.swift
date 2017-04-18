//
//  DesignableTextField.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/13/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {


    @IBInspectable var leftImage: UIImage?{
        didSet{
            updateView(viewSide: "Left", padding: 5)
        }
    }
    @IBInspectable var rightImage: UIImage?{
        didSet{
            updateView(viewSide: "Right", padding: 5)
        }
    }
    @IBInspectable var borderColor: UIColor?{
        didSet{
            layer.borderColor = borderColor!.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderRadius: CGFloat = 1{
        didSet{
            layer.cornerRadius = borderRadius
        }
    }
    
    func updateView(viewSide: String, padding: Int){
        if(viewSide == "Left"){
            if let image = leftImage{
                leftViewMode = .always
                
                let imageView = self.createSubView(x: 5, y: 0, image: image)
                leftView = imageView
                

            
            }else{
                leftViewMode = .never
            }
        }else{
            if let image = rightImage{
                rightViewMode = .always
                
                let imageView = self.createSubView(x: -2, y: 0, image: image)
                rightView = imageView
                
            }else{
                leftViewMode = .never
            }
        }
    }
    func createSubView(x: Int, y: Int, image: UIImage)->UIView{
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: 20, height: 20))
        imageView.image = image
        
        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        uiView.addSubview(imageView)

        return uiView;
    }
}
