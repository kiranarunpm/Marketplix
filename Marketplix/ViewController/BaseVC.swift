//
//  BaseVC.swift
//  SLCMComponents
//
//  Created by Kiran PM on 03/04/23.
//

import UIKit
import SideMenu
import CoreLocation
class BaseVC: UIViewController {
    let locationManager = CLLocationManager()
    lazy var chatCountVM: ChatHistoryVM = {
        return ChatHistoryVM()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadChatCount(_:)), name: Notification.Name(rawValue: "updateChatCount"), object: nil)
        initViewModels()
    }
    
    
    // MARK: InitViewModel
    func initViewModels() {
        
        chatCountVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                let data =  _self.chatCountVM.chatCountResponse?.chat_count ?? 0
                if let tabItems = _self.tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[3]
                    if data > 0{
                        tabItem.badgeValue = "\(data)"
                    }else{
                        tabItem.badgeValue = nil
                    }

                }
                
                
                
            }
        }
    }
    @objc func loadChatCount(_ notification: Notification){
        chatCountVM.callGetChatCount()
    }
    //MARK: setupSideMenu
    public func setupSideMenu() {
    }
    
    public func initiateLocation(){
        

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
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 128/255.0, green: 177/255.0, blue: 219/255.0, alpha: 0.7).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
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
    
    func showToastLogIn(message: String, tobottom: Int = 0) {
        let toastLabel = UILabel()
         toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
         toastLabel.translatesAutoresizingMaskIntoConstraints = false
         toastLabel.textColor = UIColor.white
         toastLabel.font = UIFont.boldSystemFont(ofSize: 12)
         toastLabel.textAlignment = .center
         toastLabel.text = message
         toastLabel.alpha = 1.0
         toastLabel.numberOfLines = 0
         toastLabel.clipsToBounds  =  true
         self.view.addSubview(toastLabel)
         NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            toastLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0),
            toastLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -CGFloat(tobottom)),
            toastLabel.heightAnchor.constraint(equalToConstant: 70)

        ])

         UIView.animate(withDuration: 3, delay: 5, options: .curveLinear, animations: {
             toastLabel.alpha = 0.0
         }, completion: {(isCompleted) in
             toastLabel.removeFromSuperview()
         })
     }
}
