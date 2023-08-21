//
//  BaseVC.swift
//  SLCMComponents
//
//  Created by Kiran PM on 03/04/23.
//

import UIKit
import SideMenu
import CoreLocation
class BaseVC: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: setupSideMenu
    public func setupSideMenu() {
    }
    
    public func initiateLocation(){
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func checkUsersLocationServicesAuthorization()->Bool{
        var access = false
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch self.locationManager.authorizationStatus{
                case .restricted, .denied:
                    print("No access")
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                    break
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization()
                    self.initiateLocation()
                    access = false
                    break
                case .authorizedAlways:
                    self.locationManager.requestAlwaysAuthorization()
                    print("access available")
                    self.initiateLocation()
                    access = true
                    break
                case .authorizedWhenInUse:
                    self.locationManager.requestWhenInUseAuthorization()
                    self.initiateLocation()
                    print("authorizedWhenInUse")
                    access = true
                    break
                    
                default:
                    print("unknown")
                }
                
            }
        }

        return access
    }
    
    func showAlert(){
        
        showPopupAlert(title: "Enable location services?", message: "For us to be able to help you the best we recommend that you enable location tracking.", actionTitles: ["Cancel", "Setting"], actions: [ {action1 in
            
        }, {action2 in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }])
    }
    
    public func locationManager(_ manager: CLLocationManager,
                          didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
     }

     public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         locationManager.stopUpdatingLocation()
     }
    

    
    
    @IBAction func openMenuBtnAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "DrawerMenu", bundle: nil)
        let menu = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC

//
//        let storyboard = SideMenuVC.instantiate(fromAppStoryboard: .DrawerMenu)
//        let rootNC = UINavigationController(rootViewController: storyboard)
        present(menu, animated: true, completion: nil)

    }
    
    
    //MARK: setupSideMenuSettings
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        return modes[0]
    }
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.presentingEndAlpha = 0.5

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = 300
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[0]
        settings.statusBarEndAlpha = 0
        return settings
    }
    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
    }
}
