//
//  MenuController.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/1/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {

    @IBOutlet weak var userAccountName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    let temp_image_url = "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/s60/photo.jpg"
    
    let fmDefaults = FMUserDefaults();
    
    var accountHolderName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MenuController viewDidLoad() called") 
        
        self.accountHolderName = fmDefaults.getUserDefault(forKey: AppConfig().FMDEFAULTS_ACCOUNT_HOLDER_NAME) as? String
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2;
        profileImage.layer.masksToBounds = true;
        
        if accountHolderName != "nil"{
            userAccountName.text = self.accountHolderName;
        }
        else{
            userAccountName.text = "Test";
        }
        
        self.loadProfileImage();
    }
    private func loadProfileImage(){
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: self.temp_image_url)
            
            do{
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(data: data)
                }
            }catch{
                print("error")
            }
        }
    }
}
