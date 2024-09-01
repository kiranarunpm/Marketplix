//
//  UpdateAvailableVC.swift
//  Marketplix
//
//  Created by Kiran PM on 04/07/24.
//

import UIKit

class UpdateAvailableVC: UIViewController {

    @IBOutlet weak var skipBtn: UIButton!
    var skipisActive : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        skipBtn.isHidden = skipisActive
    }
    
    
    @IBAction func updateBtn(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/in/app/marketplix-india-buy-sell/id6470384712") {
            UIApplication.shared.open(url)
        }
        
    }
    
    @IBAction func skipBtn(_ sender: Any) {
        User.shared.saveData(with: .updateAvailable, value: "true")
        self.dismiss(animated: true)
    }
    
}
