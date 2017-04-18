//
//  MyAccountController.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 3/1/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit

class MyAccountController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet var addProfileView: UIView!
    @IBOutlet weak var darkenVIew: UIView!
    @IBOutlet weak var openProfileWindow: UIButton!
    
    //Add New Profile View Items
    @IBOutlet weak var addNewProfileName: UITextField!
    @IBOutlet weak var addNewProfileGender: UITextField!
    @IBOutlet weak var addNewProfileBirthdate: UITextField!
    let genderPicker = UIPickerView()
    var newProfileGender:UserGender = .Default;
    var newProfileBirthdate:String = ""
    
    
    //DEBUG Variables
    let accountEmail = "ktommet@gmail.com"
    
    
    var userAccount: UserAccount?
    
    var test: [UserProfile]?
    
    let genderArray = UserGender.allValues
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        addNewProfileName.delegate = self
        genderPicker.delegate = self
        genderPicker.dataSource = self
        

        
        self.initGenderPicker()
        self.initDatePicker()
        
        checkNumProfiles()
        userAccount = UserAccount(email: "ktommet@gmail.com", fullname: "Kyle Tommet");
        userAccount?.addUserProfile(profile: UserProfile(name: "Kyle Tommet", email: (userAccount?.getAccountHolderEmail())!))
        
        lblFullName.text = userAccount?.getAccountHolderName()
        lblUserEmail.text = userAccount?.getAccountHolderEmail()
        
        
        
        if self.revealViewController() != nil{
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    func initGenderPicker() {
        addNewProfileGender.inputView = genderPicker
        self.addToolBar(toField: addNewProfileGender)
    }
    func initDatePicker(){
        //setting up the DatePicker
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        //setting the min/max dates
        datePickerView.minimumDate = Calendar.current.date(from: DateComponents(year: 1920, month: 1, day: 1))
        datePickerView.maximumDate = Date()
        
        datePickerView.addTarget(self, action: #selector(MyAccountController.datePickerDateChanged(sender:)), for: UIControlEvents.valueChanged)
        //adding it to the view
        addNewProfileBirthdate.inputView = datePickerView
        self.addToolBar(toField: addNewProfileBirthdate)
    }
    //every time the users selects a new date from the picker, it will update the date field
    func datePickerDateChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        addNewProfileBirthdate.text = formatter.string(from: sender.date)
        newProfileBirthdate = formatter.string(from: sender.date)
    }
    @IBAction func addNewProfile(_ sender: UIButton) {
        if let name = addNewProfileName.text{
            self.userAccount?.addUserProfile(profile: UserProfile(name: name, email: (userAccount?.getAccountHolderEmail())!))
            DispatchQueue.main.async{
                self.profileTableView.reloadData()
            }
        }
        self.checkNumProfiles()
        self.hideAddNewProfileWindow()
    }
    private func hideAddNewProfileWindow(){
        UIView.animate(withDuration: 0.3, animations: {
            self.darkenVIew.alpha = 0
        }) { (_) in
            self.addProfileView.removeFromSuperview()
        }
        
    }
    @IBAction func showNewProfileWindow(_ sender: Any) {
        self.view.addSubview(self.addProfileView);
        self.addProfileView.layer.cornerRadius = 10.0
        self.view.bringSubview(toFront: self.addProfileView)
        self.addProfileView.center = self.view.center
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.darkenVIew.alpha = 0.7
        })
    }
    @IBAction func closeProfileView(_ sender: Any) {
        self.hideAddNewProfileWindow()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userAccount?.getUserProfiles().count)!
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            test = userAccount?.getUserProfiles()
            test?.remove(at: indexPath.row)
            userAccount?.setUserProfiles(profiles: test!)
            profileTableView.reloadData()
        }
        self.checkNumProfiles()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "cell")! as! ProfileTableCell
        var profiles = userAccount?.getUserProfiles()
        cell.lblProfileName.text = profiles?[indexPath.row].getUsersName()
        
        
        return cell
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var chosenGender = self.genderArray[row] as String
        addNewProfileGender.text = chosenGender
        var gender: UserGender = UserGender.Default
        
        switch(chosenGender){
        case "Male":
            gender = UserGender.Male
        case "Female":
            gender = UserGender.Female
        case "Other":
            gender = UserGender.Other
        default:
            gender = UserGender.Default
        }
        self.newProfileGender = gender
    }
    //functions to set up the UIPickerView for the Gender Selector
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genderArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genderArray.count
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func addToolBar(toField: UITextField){
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: nil, action: #selector(MyAccountController.finishedChoosingDate))
        
        toolbar.setItems([space, button], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        toField.inputAccessoryView = toolbar
    }
    func finishedChoosingDate(){
        self.view.endEditing(true)
    }
    func checkNumProfiles(){
        if test?.count == 4{
            openProfileWindow.isEnabled = false
        }else{
            openProfileWindow.isEnabled = true
        }
    }
}
