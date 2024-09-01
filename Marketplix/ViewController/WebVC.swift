//
//  WebVC.swift
//  Marketplix
//
//  Created by Kiran PM on 10/08/24.
//

import UIKit
import MBProgressHUD
enum LoadWebType: String{
    case contact = "contact_us"
    case privacy = "privacy_policy"
    case terms = "terms_and_conditions"
    case faq = "faq"

}

class WebVC: UIViewController {
    
    var str = ""
    var loadWebType: LoadWebType = .privacy
    @IBOutlet weak var textVkew: UITextView!
    @IBOutlet weak var titleString: UILabel!

    lazy var viewModel: AuthenticationVM = {
        return AuthenticationVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        switch loadWebType {
        case .privacy:
            self.titleString.text = "Privacy Policy"
        case .terms:
            self.titleString.text = "Terms & Conditions"
         default:
            self.titleString.text = "Contact Us"

        }
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            let data = self?.viewModel.pageResponse?.page?.content ?? ""
            _self.textVkew.attributedText = data.htmlToAttributedString

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
        
        viewModel.callWebType(type: loadWebType.rawValue)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
