//
//  AccountVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit
import MBProgressHUD
import SafariServices

class AccountVC: BaseVC {

    @IBOutlet weak var phoneTxt: MPUILabel!
    @IBOutlet weak var emailTxt: MPUILabel!
    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    @IBOutlet weak var nameTxt: MPUILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTxt.text = User.shared.getSavedData(with: .email)
        self.nameTxt.text = User.shared.getSavedData(with: .name)
        self.phoneTxt.text = User.shared.getSavedData(with: .mobile)
        initViewModel()
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                User.shared.deleteUserData()
                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {
                    return
                }
                let navigationController = UINavigationController(rootViewController: rootVC)
                navigationController.navigationBar.isHidden = true
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
            }
        }
        
        viewModel.failureClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                if let alertMessage = _self.viewModel.alertMessage {
                    print("alertMessage", alertMessage)
                    
                }
            }
        }
        
        viewModel.loadingStatus = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let isLoading = _self.viewModel.isLoading ?? false
                
                if isLoading {
                    MBProgressHUD.showAdded(to: _self.view, animated: true)
                    
                }else {
                    MBProgressHUD.hide(for: _self.view, animated: true)
                }
            }
        }
    }
    
    @IBAction func myAdsBtn(_ sender: Any) {
        let vc = MyAdsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated:    true)
    }
    
    @IBAction func recentlyViewedBtn(_ sender: Any) {
        let vc = RecentlyViewedVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func subscriptionBtn(_ sender: Any) {
        let vc = SubcriptionVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout!", message: "Do you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                self.viewModel.calllogout()
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default: break
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func aboutus(_ sender: Any) {
        openURL(deeplinkURL: "https://marketplix.com/page/about_us")
    }
    
    
    @IBAction func privacyBtn(_ sender: Any) {
        openURL(deeplinkURL: "https://marketplix.com/page/privacy_policy")

    }
    
    @IBAction func contactus(_ sender: Any) {
        openURL(deeplinkURL: "https://marketplix.com/page/contact_us")

    }
    
    @IBAction func tetms(_ sender: Any) {
        openURL(deeplinkURL: "https://marketplix.com/page/terms_and_conditions")
    }
    
    
    @IBAction func faqBtn(_ sender: Any) {
        openURL(deeplinkURL: "https://marketplix.com/page/faq")

    }
    
    
    
    func openURL(deeplinkURL: String){
        if let url = URL(string: deeplinkURL) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}


