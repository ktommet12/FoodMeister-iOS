//
//  ViewController.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/1/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit
import Google
import Toast_Swift

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, DBWorkerDelegate {
    
    var googleUser: UserAccount?

    @IBOutlet weak var signInLabel: UILabel!

    @IBOutlet weak var GoogleSignInButton: UIButton!
    let fmDefaults = FMUserDefaults();
    var dbWorker = DBWorker()
    
    var hasAccount: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackgroundImage(image: UIImage(named: "Background")!)
        var error: NSError?
        
        GGLContext.sharedInstance().configureWithError(&error)
        
        if(error != nil){
            print(error as Any)
            return
        }
    
        GIDSignIn.sharedInstance().uiDelegate = self;
        GIDSignIn.sharedInstance().delegate = self;
        dbWorker.delegate = self;
        
    }
    //once the view appears check if they have signed in before and if they have send them to main app.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let signedInEmail: String? = fmDefaults.getUserDefault(forKey: AppConfig().FMDEFAULTS_ACCOUNT_HOLDER_EMAIL) as? String
        
        if signedInEmail != nil{
            print("User Still Logged in Transferring to Main App");
            self.view.isHidden = true;
            self.FMperformSegue(identifier: "goToMainApp")
        }
    }
    //handles when the user selects a google profile to sign in with
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if(error == nil){
            googleUser = UserAccount(id: 0, email: user.profile.email, fullname: user.profile.name)
            googleUser?.profileImageURL = user.profile.imageURL(withDimension: 60)
            print(user.profile.imageURL(withDimension: 60))
            handleSignInRequest()
        }else{
            print(error)
        }
    }
    //sign in button clicked from storyboard
    @IBAction func googleSignInClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        self.view.makeToastActivity(.center)
    }
    //prepares the VC on the register new user page and sends the currently in progress account
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showRegister"){
            print("Trying to go to Register")
            if let registerVC = segue.destination as? RegisterNewAccountController {
                registerVC.parentAccount = googleUser
            }
        }
    }
    func handleSignInRequest(){
        //checks if they exist in DB, once that finishes it will call the didFinishTask()
        _ = self.dbWorker.userExistsinDB(email: (googleUser?.getAccountHolderEmail())!)
        _ = "";
    }
    func addBackgroundImage(image: UIImage){
        //adding the image as the background image
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    private func FMperformSegue(identifier: String){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: nil)
        }
    }
    func didFinishTask(returnedJSON: [String : Any]?, wasASuccess: Bool) {
        if wasASuccess{
            let isUserRegistered:Bool = (returnedJSON?["account_exists"] as? Bool)!
            if isUserRegistered{
                let fmUserDefaults = FMUserDefaults();
                fmUserDefaults.addUserDefault(forKey: AppConfig().FMDEFAULTS_ACCOUNT_HOLDER_NAME, data: (returnedJSON?["full Name"] as? String)!)
                fmUserDefaults.addUserDefault(forKey: AppConfig().FMDEFAULTS_ACCOUNT_HOLDER_EMAIL, data: (returnedJSON?["email"] as? String)!)
                self.FMperformSegue(identifier: "goToMainApp")
            }else{
                self.FMperformSegue(identifier: "showRegister")
            }
        }
    }
}

