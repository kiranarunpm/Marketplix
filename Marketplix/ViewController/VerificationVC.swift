//
//  VerificationVC.swift
//  Marketplix
//
//  Created by Kiran PM on 20/04/23.
//

import UIKit
import MBProgressHUD

class VerificationVC: BaseVC {
    var counter = 60
    var request: RegisterRequest?

    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    var isFromLogin: Bool = true
    @IBOutlet weak var code1: MarketField!
    @IBOutlet weak var code2: MarketField!
    @IBOutlet weak var code3: MarketField!
    @IBOutlet weak var code4: MarketField!
    var email = ""
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var timeTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        
        super.viewDidLoad()
        code1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        code2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        code3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        code4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        initViewModel()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text ?? ""
        if  text.utf16.count == 1 {
            switch textField{
            case code1:
                code2.becomeFirstResponder()
            case code2:
                code3.becomeFirstResponder()
            case code3:
                code4.becomeFirstResponder()
            case code4:
                self.view.endEditing(true)
            default:
                break
            }
        }

        if  text.count == 0 {
            if let char = textField.text!.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        switch textField{
                        case code1:
                            code1.becomeFirstResponder()
                        case code2:
                            code1.becomeFirstResponder()
                        case code3:
                            code2.becomeFirstResponder()
                        case code4:
                            code3.becomeFirstResponder()
                        default:
                            break
                        }
                    }
                }

        }

    }
    
    //MARK: HANDLE EMPTY TEXTFIELD DELETE BUTTON
    func handleEmptyTFDelete(){
        code1.completionBlock = { success in
            if success{
                self.code1.becomeFirstResponder()
            }
       }
        
        code2.completionBlock = { success in
            if success{
                self.code1.becomeFirstResponder()
            }
       }
        
        code3.completionBlock = { success in
            if success{
                self.code2.becomeFirstResponder()
            }
       }
        
        code4.completionBlock = { success in
            if success{
                self.code3.becomeFirstResponder()
            }
       }
    
    }
    
    //MARK: TO HANDLE NEXT TF
    func handleMoveTFtoNext(){
        code1.completionBlockToNextTF = { success in
            if success{
                self.code2.becomeFirstResponder()
            }
       }
        
        code2.completionBlockToNextTF = { success in
            if success{
                self.code3.becomeFirstResponder()
            }
       }
        
        code3.completionBlockToNextTF = { success in
            if success{
                self.code4.becomeFirstResponder()
            }
       }
        
        code4.completionBlockToNextTF = { success in
            if success{
                self.view.endEditing(true)
            }
       }
      
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
                
                let details = self?.viewModel.loginResponse
                User.shared.saveData(with: .accessToken, value: details?.token ?? "")
                User.shared.saveData(with: .name, value: details?.user?.first_name ?? "")
                User.shared.saveData(with: .email, value: details?.user?.email ?? "")
                User.shared.saveData(with: .mobile, value: details?.user?.phone ?? "")


                print("Token: : \(details)")
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
                    _self.showToastLogIn(message: alertMessage)
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
        if isFromLogin{
            let request = LoginRequest(email: self.email, otp: code)
            viewModel.callLogin(request)
        }else{
            request?.otp = code
            if let request = self.request{
                viewModel.callRegister(request)
            }
        }
    }
}

class MarketField:  UITextField{
    typealias emptyDeleteTFBlock = (_ success: Bool) -> Void
    var completionBlock: emptyDeleteTFBlock? = nil
    
    typealias moveNextTFBlock = (_ success: Bool) -> Void
    var completionBlockToNextTF: moveNextTFBlock? = nil
    
    @objc func textFieldDidChange(textField : UITextField) {
            if textField.text?.count == 1{
                completionBlockToNextTF?(true)
            }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if delegate == nil{
            delegate = self
        }
        self.borderStyle = .none
        self.textAlignment = .center
        
    }
    
}
extension MarketField: UITextFieldDelegate{
    func formatMobile(_ range: NSRange, string: String, count: Int?) -> Bool {
        
        if string.rangeOfCharacter(from: NSCharacterSet(charactersIn: "0123456789").inverted) != nil{
            return false
        }
        let newRange = self.text!.index(self.text!.startIndex, offsetBy: range.location)..<self.text!.index(self.text!.startIndex, offsetBy: range.location + range.length)
        let newString = self.text!.replacingCharacters(in: newRange, with: string)
        if newString.count > count ?? 0{
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var returnValue = true
        returnValue = formatMobile(range, string: string, count: 1)
        if returnValue == false{
            textFieldDidChange(textField: textField)
        }
        return returnValue
    }
}
