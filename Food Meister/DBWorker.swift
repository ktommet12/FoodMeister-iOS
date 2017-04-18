//
//  DBWorker.swift
//  Food Meister
//
//  Created by KYLE TOMMET on 2/11/17.
//  Copyright © 2017 KYLE TOMMET. All rights reserved.
//

import MapKit

class DBWorker{
    var delegate : DBWorkerDelegate?
    static var isTaskInProgress: Bool = false
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    
    init(){
    }
    func performNetworkRequest(url: String){
        let _URL = URL(string: url)
        let request = URLRequest(url: _URL!);
        if DBWorker.isTaskInProgress == false{
            performTask(urlRequest: request)
        }
    }
    func getLocalSearchResults(location: CLLocationCoordinate2D){
        var googlePlacesUrl = GoogleUrls().GooglePlacesTextSearch;
        googlePlacesUrl += "location=" + String(location.latitude) + "," + String(location.longitude);
        googlePlacesUrl += "&radius=" + String(FMMap().DEFAULT_SEARCH_RADIUS);
        googlePlacesUrl += "&types=" + FMMap().DEFAULT_SEARCH_TYPE;
        googlePlacesUrl += "&sensor=true";
        googlePlacesUrl += "&key=AIzaSyDb6lfUgRFMfGgeI5yUZtfjFrFiwDB6v-M";
        
        
        
        print("Google Places URL: \(googlePlacesUrl)")
        self.performNetworkRequest(url: googlePlacesUrl)
    }
    func userExistsinDB(email: String){
        let userExistsURL = "http://www.thefoodmeister.com/verify-login-android.php?email="+email
        let url = URL(string: userExistsURL)
        let request = URLRequest(url: url!)
        
        
        
        self.performTask(urlRequest: request);
            
        
    }
    func savePicToFile(){
        
    }
    func createNewAccount(account: UserAccount){
        let registerURL = "http://www.thefoodmeister.com/register-new-user.php?email=" + account.getAccountHolderEmail() + "&fullName=" + DBWorker.prepareStringforURL(string: account.getAccountHolderName())
        print("registerURL: \(registerURL)")
        let url = URL(string: registerURL)
        let request = URLRequest(url: url!)
        
        self.performTask(urlRequest: request)

    }
    private func performTask(urlRequest: URLRequest){
        let task = session.dataTask(with: urlRequest){
            (data, response, error) -> Void in
            
            if let jsonData = data{
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    let jsonResponse = jsonObject as? [String: Any]
                    self.delegate?.didFinishTask(returnedJSON: jsonResponse, wasASuccess: true)
                    
                }catch let error{
                    print("Error Parsing Json Data \(error)");
                    self.delegate?.didFinishTask(returnedJSON: nil, wasASuccess: false)
                }
            }else if let requestError = error{
                print("Error: \(error?.localizedDescription)")
                self.delegate?.didFinishTask(returnedJSON: nil, wasASuccess: false)
            }else{
                print("Unexpected Error")
                self.delegate?.didFinishTask(returnedJSON: nil, wasASuccess: false)
            }
        }
        task.resume()
    }
    static func prepareStringforURL(string: String)->String{
        return string.replacingOccurrences(of: " ", with: "%20")
    }
}
