//
//  LoginVC.swift
//  Marketplix
//
//  Created by Kiran PM on 20/04/23.
//

import UIKit
import MBProgressHUD
import SafariServices

class CustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

protocol LoginDelegate{
    func refreshUI()
}
class LoginVC: BaseVC, UITextPasteDelegate {
    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: any UITextPasteConfigurationSupporting, shouldAnimatePasteOf attributedString: NSAttributedString, to textRange: UITextRange) -> Bool {
        return false
    }
    
    @IBOutlet weak var privacyCheckBtn: UIButton!
    @IBOutlet weak var termsCheckBtn: UIButton!
    
    @IBOutlet weak var emailTxt: CustomTextField!
    var isfromMain: Bool = false
    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    var delegate: LoginDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        self.emailTxt.keyboardType = .numberPad
        self.emailTxt.pasteDelegate = self
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
                    storyboard.otpMessage = details?.message ?? ""
                    storyboard.isfromMain = _self.isfromMain
                    
                    storyboard.delegate = _self
                    if !_self.isfromMain{
                         storyboard.modalPresentationStyle = .overCurrentContext
                        _self.present(storyboard, animated: true)

                    }else{
                        _self.navigationController?.pushViewController(storyboard, animated: true)
                    }
                    return
                }
                
                    print("message: : \(details?.message)")
                    let storyboard = VerificationVC.instantiate(fromAppStoryboard: .Main)
                    storyboard.email = _self.emailTxt.text ?? ""
                    storyboard.isFromLogin = true
                     storyboard.delegate = self
                     storyboard.otpMessage = details?.message ?? ""
                     storyboard.isfromMain = _self.isfromMain
                if !_self.isfromMain{
                     storyboard.modalPresentationStyle = .overCurrentContext
                    _self.present(storyboard, animated: true)

                }else{
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
//        if privacyCheckBtn.tag == 0 && termsCheckBtn.tag == 0{
//            showToastLogIn(message: "Please accept privacy policy and terms and conditions")
//             return
//        }
//        if privacyCheckBtn.tag == 0{
//            showToastLogIn(message: "Please read and accept privacy policy")
//             return
//        }
//        if termsCheckBtn.tag == 0{
//            showToastLogIn(message: "Please read and accept terms and conditions")
//             return
//        }


        
        guard let email = self.emailTxt.text, email != "" else {
            return
        }
        var key = "phone"
        if email.isValidPhone(phone: email){
            
        }else{
            if email.isValidEmail(email: email){
                key = "email"
            }else{
                showToastLogIn(message: "Please enter email address")

            }
        }
        
        let request = [key: email]
        viewModel.callGenerateOTP(request)
        
    }
    
    @IBAction func privacyBtn(_ sender: Any) {
        let vc = WebVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.loadWebType = .privacy
        self.navigationController?.present(vc, animated: true)
    }
    
    
    @IBAction func termsBtn(_ sender: Any) {
        let vc = WebVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.loadWebType = .terms
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func privacyCheckBtn(_ sender: Any) {
        if privacyCheckBtn.tag == 0{
            privacyCheckBtn.tag = 1
        }else{
            privacyCheckBtn.tag = 0
        }
        let image = privacyCheckBtn.tag == 1 ? UIImage(named: "checkbox-check login") : UIImage(named: "checkbox-unchecked login")
        self.privacyCheckBtn.setImage(image, for: .normal)

    }
    
    @IBAction func termsCheckBtn(_ sender: Any) {
        if termsCheckBtn.tag == 0{
            termsCheckBtn.tag = 1
        }else{
            termsCheckBtn.tag = 0
        }
        let image = termsCheckBtn.tag == 1 ? UIImage(named: "checkbox-check login") : UIImage(named: "checkbox-unchecked login")
        self.termsCheckBtn.setImage(image, for: .normal)

    }
    
    func openURL(deeplinkURL: String){
        if let url = URL(string: deeplinkURL) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func skipBtn(_ sender: Any) {
        User.shared.saveData(with: .isPressSkip, value: "true")
        if !isfromMain{
            self.dismiss(animated: true)
            return
        }
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? MainTabVC else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}

extension LoginVC: VerificationDelegate, RegisterDelegate{
    func dismissRegistationPage() {
        self.dismiss(animated: false)
    }
    
    func dismissLoginPage() {
        self.dismiss(animated: false)
        delegate?.refreshUI()
    }
    
    
}


extension String{
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
        }
    
    func isValidEmail(email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
}
