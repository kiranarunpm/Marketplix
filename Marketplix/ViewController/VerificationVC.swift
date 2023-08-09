//
//  VerificationVC.swift
//  Marketplix
//
//  Created by Kiran PM on 20/04/23.
//

import UIKit
import MBProgressHUD

class VerificationVC: UIViewController {
    var counter = 60

    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    
    @IBOutlet weak var code1: UITextField!
    @IBOutlet weak var code2: UITextField!
    @IBOutlet weak var code3: UITextField!
    @IBOutlet weak var code4: UITextField!
    
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var timeTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        initViewModel()
    }
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            counter -= 1
            self.timeTxt.isHidden = false
            self.timeTxt.text = "0:\(counter)"
            self.resendBtn.isUserInteractionEnabled = false
            self.resendBtn.setTitleColor(.gray, for: .normal)
        }
        else{
            self.timeTxt.isHidden = true
            self.resendBtn.isUserInteractionEnabled = true
            self.resendBtn.setTitleColor(.systemBlue, for: .normal)
        }
    }

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        
        viewModel.successClosure = { [weak self] () in
            
            guard self != nil else { return }
            
            DispatchQueue.main.async {
                
                let details = self?.viewModel.loginResponse?.token ?? ""
                print("Token: : \(details)")
                
                let vc = HomeVC.instantiate(fromAppStoryboard: .Main)
                vc.navigationController?.pushViewController(vc, animated: true)
                
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

    
    @IBAction func verifyBtn(_ sender: Any) {
        let code = code1.text! + code2.text! + code3.text! + code4.text!
        let request = LoginRequest(email: "test2@gmail.com", otp: code)
        viewModel.callLogin(request)
//        let storyboard = MainTabVC.instantiate(fromAppStoryboard: .Main)
//        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    

}
