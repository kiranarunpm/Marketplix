//
//  AccountVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit
import MBProgressHUD
import SafariServices

class AccountVC: BaseVC, LoginDelegate {
    func refreshUI() {
        setUpUI()
    }

    

    @IBOutlet weak var phoneTxt: MPUILabel!
    @IBOutlet weak var emailTxt: MPUILabel!
    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    
    lazy var accountDeleteVM: HomeVM = {
        return HomeVM()
    }()
    
    @IBOutlet weak var signInBtn: MPUIButton!
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var nameTxt: MPUILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    func setUpUI(){
        self.emailTxt.text = User.shared.getSavedData(with: .email)
        self.nameTxt.text = User.shared.getSavedData(with: .name)
        self.phoneTxt.text = User.shared.getSavedData(with: .mobile)
        if User.shared.getSavedData(with: .email) == ""{
            self.emailTxt.isHidden = true
        }else{
            self.emailTxt.isHidden = false
        }
        if User.shared.getSavedData(with: .name) == ""{
            self.nameTxt.isHidden = true
        }else{
            self.nameTxt.isHidden = false

        }
        if User.shared.getSavedData(with: .mobile) == ""{
            self.phoneTxt.isHidden = true
        }else{
            self.phoneTxt.isHidden = false
        }
        
        if User.shared.getSavedData(with: .accessToken) == ""{
            self.signInBtn.isHidden = false
            self.deleteView.isHidden = true
            self.logoutView.isHidden = true

        }else{
            self.signInBtn.isHidden = true
            self.deleteView.isHidden = false
            self.logoutView.isHidden = false


        }
    }
    // MARK: InitViewModel
    func initViewModel() {
        
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                User.shared.deleteUserData()
                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? MainTabVC else {
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
        
        accountDeleteVM.successClosure = { [weak self] () in
            
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
    }
    
    @IBAction func myAdsBtn(_ sender: Any) {
        if !User.shared.hasToken {
            let vc = LoginVC.instantiate(fromAppStoryboard: .Main)
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(vc, animated: true)
            return
        }
        
        let vc = MyAdsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated:    true)
    }
    
    @IBAction func recentlyViewedBtn(_ sender: Any) {
        if !User.shared.hasToken {
            let vc = LoginVC.instantiate(fromAppStoryboard: .Main)
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(vc, animated: true)
            return
        }
        let vc = RecentlyViewedVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func subscriptionBtn(_ sender: Any) {
        if !User.shared.hasToken {
            let vc = LoginVC.instantiate(fromAppStoryboard: .Main)
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(vc, animated: true)
            return
        }
        let vc = SubcriptionVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .alert)
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
    
    @IBAction func accountDelete(_ sender: Any) {
        
        let alert = UIAlertController(title: "Account Delete", message: "Do you want to delete your Account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                self.accountDeleteVM.callDeleteAccount()
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
        openURL(deeplinkURL: "https://marketplix.in/page/about_us")
    }
    
    
    @IBAction func privacyBtn(_ sender: Any) {
        let vc = WebVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.loadWebType = .privacy
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func contactus(_ sender: Any) {
        let vc = WebVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.loadWebType = .contact
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func tetms(_ sender: Any) {
        let vc = WebVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.loadWebType = .terms
        self.navigationController?.present(vc, animated: true)    }
    
    
    @IBAction func faqBtn(_ sender: Any) {
        let vc = WebVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.loadWebType = .faq
        self.navigationController?.present(vc, animated: true)
    }
    
    
    
    func openURL(deeplinkURL: String){
        if let url = URL(string: deeplinkURL) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func openLink(_ url: String){
        guard let url = URL(string: url) else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func fbBtn(_ sender: Any) {
        openLink("https://www.facebook.com/Marketplix?mibextid=LQQJ4d")
    }
    
    
    @IBAction func linkedIn(_ sender: Any) {
        openLink("https://www.linkedin.com/company/marketplix/?viewAsMember=true")
    }
    
    @IBAction func instagram(_ sender: Any) {
        openLink("https://www.instagram.com/marketplix_india?igsh=cDVwNTA1a216OTJn&utm_source=qr")
    }
    
    @IBAction func whatsapp(_ sender: Any) {
        openLink("https://whatsapp.com/channel/0029VaX4JrRD38CSLP2wQI2M")
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        let vc = LoginVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
    
    
}


