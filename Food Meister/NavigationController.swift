//
//  NavigationController.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/21/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

class NavigationController: UIViewController {

    @IBOutlet weak var openMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }
}
