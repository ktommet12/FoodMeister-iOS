//
//  SettingsController.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/4/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var menuItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil{
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

}
