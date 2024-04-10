//
//  LoginVC.swift
//  Marketplix
//
//  Created by Kiran PM on 20/04/23.
//

import UIKit
import MBProgressHUD

class LoginVC: BaseVC {
    
    @IBOutlet weak var emailTxt: UITextField!
    
    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
//        self.emailTxt.text = "q@gm.com"
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.viewModel.getOtpResponse
                if details?.exist_user ?? 0 == 0{
                    let storyboard = RegisterVC.instantiate(fromAppStoryboard: .Main)
                    storyboard.email = _self.emailTxt.text ?? ""
                    _self.navigationController?.pushViewController(storyboard, animated: true)
                    return
                }
                
                print("message: : \(details?.message)")
                    let storyboard = VerificationVC.instantiate(fromAppStoryboard: .Main)
                    storyboard.email = _self.emailTxt.text ?? ""
                    storyboard.isFromLogin = true
                    _self.navigationController?.pushViewController(storyboard, animated: true)
                
                
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
    
    
    
    @IBAction func signInBtn(_ sender: Any) {
        guard let email = self.emailTxt.text, email != "" else {
            showToastLogIn(message: "Please enter email address")
            return
        }
        
        let request = GetOtpRequest(email: email)
        viewModel.callGenerateOTP(request)
        
    }
    
    
}
