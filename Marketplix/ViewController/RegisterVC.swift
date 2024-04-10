//
//  RegisterVC.swift
//  Marketplix
//
//  Created by Kiran PM on 18/04/23.
//

import UIKit
import MBProgressHUD
class RegisterVC: BaseVC {
    var email = ""

    @IBOutlet weak var userTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    var request: RegisterRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTxt.text = email
        self.emailTxt.isEnabled = false
    }
    

    
    @IBAction func registerBtn(_ sender: Any) {
        
        guard let username = self.userTxt.text, !username.isEmpty else {
            self.showToastLogIn(message: "Please enter username")
            return
        }
        
        guard let mobile = self.mobileTxt.text else {
            self.showToastLogIn(message: "Please enter valid mobile number")
            return
        }
        
        guard let email = self.emailTxt.text, email.isValidEmail() else {
            self.showToastLogIn(message: "Please enter valid email address")
            return
        }
        
        let request = RegisterRequest(first_name: username, otp: "", email: email,dob: "10/02/2002")
        
        let storyboard = VerificationVC.instantiate(fromAppStoryboard: .Main)
        storyboard.email = self.emailTxt.text ?? ""
        storyboard.isFromLogin = false
        storyboard.request = request
        self.navigationController?.pushViewController(storyboard, animated: true)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
