//
//  UiBtnExtension.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/1/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import Foundation
extension UIButton{
    func showLoadingBtn(_ show: Bool){
        let tag = 7515
        if(show){
            self.isEnabled = true;
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height;
            let buttonWidth = self.bounds.size.width;
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            self.titleLabel?.isHidden = true;
            indicator.startAnimating()
        }else{
            self.isEnabled = true;
            self.alpha = 1.0;
            self.titleLabel?.isHidden = false;
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView{
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
