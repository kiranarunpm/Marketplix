//
//  BaseVC.swift
//  SLCMComponents
//
//  Created by Kiran PM on 03/04/23.
//

import UIKit
import SideMenu
class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: setupSideMenu
    public func setupSideMenu() {
    }
    
    
    @IBAction func openMenuBtnAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "DrawerMenu", bundle: nil)
        let menu = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC

//
//        let storyboard = SideMenuVC.instantiate(fromAppStoryboard: .DrawerMenu)
//        let rootNC = UINavigationController(rootViewController: storyboard)
        present(menu, animated: true, completion: nil)

    }
    
    
    //MARK: setupSideMenuSettings
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        return modes[0]
    }
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.presentingEndAlpha = 0.5

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = 300
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[0]
        settings.statusBarEndAlpha = 0
        return settings
    }
    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
    }
}
