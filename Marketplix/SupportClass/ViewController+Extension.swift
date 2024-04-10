//
//  ViewController+Extension.swift
//  Marketplix
//
//  Created by Kiran P M on 14/08/23.
//

import UIKit

extension UIViewController{
    
    func toHome() {
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func showPopupAlert( title: String,  message: String, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, title) in actionTitles.enumerated() {
            
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
}


