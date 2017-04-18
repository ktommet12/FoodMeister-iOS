//
//  LogOutController.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/5/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit
import Toast_Swift

class LogOutController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fmDefaults = FMUserDefaults();
        fmDefaults.deleteUserDefault(forKey: "AccountHolderName")
        fmDefaults.deleteUserDefault(forKey: "SignedInEmail")
        self.view.makeToastActivity(.center)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: transfer user back to log in screen
        performSegue(withIdentifier: "goToLogin", sender: nil)

    }
}
