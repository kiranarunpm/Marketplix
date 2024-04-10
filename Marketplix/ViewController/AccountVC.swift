//
//  AccountVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit

class AccountVC: UIViewController {

    @IBOutlet weak var phoneTxt: MPUILabel!
    @IBOutlet weak var emailTxt: MPUILabel!

    @IBOutlet weak var nameTxt: MPUILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTxt.text = User.shared.getSavedData(with: .email)
        self.nameTxt.text = User.shared.getSavedData(with: .name)
        self.phoneTxt.text = User.shared.getSavedData(with: .mobile)

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
