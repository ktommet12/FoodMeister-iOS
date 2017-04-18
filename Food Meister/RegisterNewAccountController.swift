//
//  RegisterNewAccountController.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/6/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import UIKit
import Toast_Swift


class RegisterNewAccountController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DBWorkerDelegate{
    
    var parentAccount: UserAccount?
    var newProfile: UserProfile?
    
    var isInfoFilledOutFully:Bool = false;
    
    
    
  
    @IBOutlet weak var txtNameField: UITextField!
    @IBOutlet weak var txtBirthdateField: UITextField!
    @IBOutlet weak var txtGenderField: UITextField!
    @IBOutlet weak var txtEmailFIeld: UITextField!
    
    
    @IBOutlet weak var createNewAccount: UIButton!
    
    @IBOutlet weak var milkSwitch: CustomSwitch!
    
    
    
    
    let genderPicker = UIPickerView()
    var dbWorker = DBWorker();
    
    let genderArray = UserGender.allValues
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackgroundImage(image: UIImage(named: "Background")!)
        initDatePicker()
        initGenderPicker()
        
        
        //setting up delegates
        txtNameField.delegate = self
        genderPicker.delegate = self
        genderPicker.dataSource = self
        dbWorker.delegate = self;

        //loading whatever info we can for the user, whatever information was provided by Google, Facebook etc
        self.loadUserInfo();
    }
    //sends the user to the MapController, calls the segue prepare function first
    @IBAction func registerNewAccount(_ sender: UIButton) {
        print("Attempting to Register New Account...")
        self.isInfoFilledOutFully = checkInputFields()
        
        if(isInfoFilledOutFully != false){
            self.createNewAccount.showLoadingBtn(true)
            self.dbWorker.createNewAccount(account: parentAccount!)     //initiate contact with server for registration
        }else{
            self.view.makeToast("Please input all information", duration: 3.0, position: .top)
        }
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        self.isInfoFilledOutFully = checkInputFields()
        print("Parent Account: \(parentAccount?.toString())")
        print("User Profile: \(newProfile?.toString())")
        if(isInfoFilledOutFully == false){
            self.view.makeToast("There were fields left empty", duration: 3.0, position: .bottom);
            return false;
        }
        else {return true;}
    }
    
    func initDatePicker(){
        //setting up the DatePicker
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        //setting the min/max dates
        datePickerView.minimumDate = Calendar.current.date(from: DateComponents(year: 1920, month: 1, day: 1))
        datePickerView.maximumDate = Date()
        
        datePickerView.addTarget(self, action: #selector(RegisterNewAccountController.datePickerDateChanged(sender:)), for: UIControlEvents.valueChanged)
        //adding it to the view
        txtBirthdateField.inputView = datePickerView
        self.addToolBar(toField: txtBirthdateField)
    }
    func finishedChoosingDate(){
        self.view.endEditing(true)
    }
    
    func initGenderPicker() {
        txtGenderField.inputView = genderPicker
        self.addToolBar(toField: txtGenderField)
    }
    //every time the users selects a new date from the picker, it will update the date field
    func datePickerDateChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        txtBirthdateField.text = formatter.string(from: sender.date)
        newProfile?.birthdate = formatter.string(from: sender.date)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var chosenGender = self.genderArray[row] as String
        txtGenderField.text = chosenGender
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
        newProfile?.gender = gender
    }
    
    //when a switch is toggled
    @IBAction func SwitchToggled(_ sender: UISwitch) {
        switch(sender.tag){
        case 1:
            newProfile?.toggleAllergy(name: "Milk")
        case 2:
            newProfile?.toggleAllergy(name: "Egg")
        case 3:
            newProfile?.toggleAllergy(name: "Wheat")
        case 4:
            newProfile?.toggleAllergy(name: "Tree Nuts")
        case 5:
            newProfile?.toggleAllergy(name: "Peanut")
        case 6:
            newProfile?.toggleAllergy(name: "Soy")
        case 7:
            newProfile?.toggleAllergy(name: "Fish")
        case 8:
            newProfile?.toggleAllergy(name: "Shellfish")
        default:
            print("Error Toggling Allergy, Sender Tag: \(sender.tag)")
        }
        print(newProfile?.getAllergies())
    }
    func addToolBar(toField: UITextField){
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: nil, action: #selector(RegisterNewAccountController.finishedChoosingDate))
        
        toolbar.setItems([space, button], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        toField.inputAccessoryView = toolbar
    }
    func addBackgroundImage(image: UIImage){
        //setting the background of the app
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    func loadUserInfo(){
        txtNameField.text = parentAccount?.getAccountHolderName()
        txtEmailFIeld.text = parentAccount?.getAccountHolderEmail()
        
        self.newProfile = UserProfile(name: (parentAccount?.getAccountHolderName())!, email: (parentAccount?.getAccountHolderEmail())!);
    }
    func addErrorDisplay(sender: UITextField){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "error")
        imageView.image = image
        sender.rightViewMode = .always
        sender.rightView = imageView
    }
    func checkInputFields()->Bool{
        var isCorectInfo:Bool = true
        if(txtNameField.text == ""){
            addErrorDisplay(sender: txtNameField)
            isCorectInfo = false
        }
        else{
            txtNameField.rightViewMode = .never
        }
        if(txtBirthdateField.text == ""){
            addErrorDisplay(sender: txtBirthdateField)
            isCorectInfo = false;
        }
        else{
            txtBirthdateField.rightViewMode = .never
        }
        if(txtGenderField.text == ""){
            addErrorDisplay(sender: txtGenderField)
            isCorectInfo = false;
        }
        else{
            txtGenderField.rightViewMode = .never
        }
        if(txtEmailFIeld.text == ""){
            addErrorDisplay(sender: txtEmailFIeld)
            isCorectInfo = false
        }
        return isCorectInfo;
    }
    //DBWorkerDelegate Method for when the register action cames back from server
    func didFinishTask(returnedJSON: [String: Any]?, wasASuccess: Bool) {
        if(wasASuccess == true){
            let fmDefaults = FMUserDefaults()
            //adding the userAccount variables to defaults for easier access later by other parts of the program.
            fmDefaults.addUserDefault(forKey: AppConfig().FMDEFAULTS_ACCOUNT_HOLDER_NAME, data: parentAccount!.getAccountHolderName())
            fmDefaults.addUserDefault(forKey: AppConfig().FMDEFAULTS_ACCOUNT_HOLDER_EMAIL, data: parentAccount!.getAccountHolderEmail())
            
            //transferring the user to the map screen
            print("Segueing to Map")
            performSegue(withIdentifier: "showMapSegue", sender: nil)
        }else{
            //Account was Not Created Successfully
            DispatchQueue.main.async {
                self.view.makeToast("Problem Creating Account", duration: 3.0, position: .top);
                self.createNewAccount.showLoadingBtn(false)
            }
            
        }
    }
}
