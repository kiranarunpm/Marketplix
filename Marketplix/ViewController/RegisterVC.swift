//
//  RegisterVC.swift
//  Marketplix
//
//  Created by Kiran PM on 18/04/23.
//

import UIKit
import MBProgressHUD
import DatePickerDialog
protocol RegisterDelegate{
    func dismissRegistationPage()
}
class RegisterVC: BaseVC {
    var email = ""

    @IBOutlet weak var userTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    var delegate: RegisterDelegate?
    var isfromMain: Bool = false

    var request: RegisterRequest?
    var otpMessage = ""
    @IBOutlet weak var dateTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if email.isValidPhone(phone: email){
            self.mobileTxt.text = email
            self.mobileTxt.isEnabled = false
        }else{
            self.emailTxt.text = email
            self.emailTxt.isEnabled = false
        }
      
        
        
        showToastLogIn(message: otpMessage)
    }
    

    @IBAction func datePickerBtn(_ sender: Any) {
        datePickerTapped()
    }
    
    func datePickerTapped() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.dateTxt.text = formatter.string(from: dt)
            }
        }
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
        
        
        let request = RegisterRequest(first_name: username, otp: "", email: email, phone: mobile)
        
        let storyboard = VerificationVC.instantiate(fromAppStoryboard: .Main)
        storyboard.email = self.emailTxt.text ?? ""
        storyboard.isFromLogin = false
        storyboard.request = request
        storyboard.isfromMain = isfromMain
        storyboard.delegate = self
        if !self.isfromMain{
             storyboard.modalPresentationStyle = .overCurrentContext
            self.present(storyboard, animated: true)

        }else{
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        if !(self.isfromMain){
            self.dismiss(animated: true)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }


}
extension RegisterVC: VerificationDelegate{
    func dismissLoginPage() {
        self.dismiss(animated: false)
        self.delegate?.dismissRegistationPage()
    }
    
    
}
