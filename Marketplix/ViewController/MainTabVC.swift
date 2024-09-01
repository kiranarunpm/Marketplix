//
//  MainTabVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit

class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is FavouriteVC{
            if !User.shared.hasToken {
                let vc = LoginVC.instantiate(fromAppStoryboard: .Main)
                vc.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(vc, animated: true)
                self.selectedIndex = 0
                return
            }
        }
       
        if viewController is ChatVC{
            if !User.shared.hasToken {
                let vc = LoginVC.instantiate(fromAppStoryboard: .Main)
                vc.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(vc, animated: true)
                self.selectedIndex = 0
                return
            }
        }
        if viewController is PostPropertyVC{
            if !User.shared.hasToken {
                let vc = LoginVC.instantiate(fromAppStoryboard: .Main)
                vc.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(vc, animated: true)
                self.selectedIndex = 0
                return
            }
        }
    }
}

