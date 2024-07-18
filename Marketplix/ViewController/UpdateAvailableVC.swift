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
        
        
    }
    
    @IBAction func skipBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
