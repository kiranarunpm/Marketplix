//
//  LoginVC.swift
//  Marketplix
//
//  Created by Kiran PM on 20/04/23.
//

import UIKit
import MBProgressHUD

class LoginVC: UIViewController {

    
    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.viewModel.getOtpResponse?.message ?? ""
                
                print("message: : \(details)")
                DispatchQueue.main.async {
                            let storyboard = VerificationVC.instantiate(fromAppStoryboard: .Main)
                            _self.navigationController?.pushViewController(storyboard, animated: true)
                }
                
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
        
        let request = GetOtpRequest(email: "test3@gmail.com")
        viewModel.callGenerateOTP(request)

    }
    

}
