//
//  AllowAccessVC.swift
//  Marketplix
//
//  Created by Kiran on 08/06/24.
//

import Foundation
import UIKit
import CoreLocation


class AllowAccessVC: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{

    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func allowBtn(_ sender: Any) {
        configureNotification()
        setupLocation()
        
        
        User.shared.saveData(with: .isEnableAllowAccess, value: "true")
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
        User.shared.saveData(with: .isEnableAllowAccess, value: "true")

    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func configureNotification() {
        if #available(iOS 10.0, *) {
                  UNUserNotificationCenter.current().delegate = self
                  let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                  UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
                } else {
                  let settings: UIUserNotificationSettings =
                  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                let locality = placemark.locality ?? ""
                let replaceSpace = locality.replacingOccurrences(of: " ", with: "_")
   
                
                self.locationManager.stopUpdatingLocation()
                User.shared.saveData(with: .location, value: locality)
                User.shared.saveData(with: .lat, value: userLocation.coordinate.latitude.description)
                User.shared.saveData(with: .long, value: userLocation.coordinate.longitude.description)


                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLocation"), object: nil, userInfo: nil)
                self.dismiss(animated: true)

               
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}



