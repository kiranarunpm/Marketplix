//
//  HomeVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit
import ImageSlideshow
import MBProgressHUD


class HomeVC: BaseVC {
    let names = ["Searh Land", "Search Property", "Search Car", "Search Laptops"]
    let sectionArr = ["search","banner", "header","Main categories", "header", "Featured Listing", "header", "New Listing", "header", "Recommendations"]
    
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    
    var flashArr = [Flash]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: HomeSearchCell.identifire, bundle: nil), forCellReuseIdentifier: HomeSearchCell.identifire)
        self.tableView.register(UINib(nibName: HomeBannerCell.identifire, bundle: nil), forCellReuseIdentifier: HomeBannerCell.identifire)
        self.tableView.register(UINib(nibName: TitleHeaaderCell.identifire, bundle: nil), forCellReuseIdentifier: TitleHeaaderCell.identifire)
        self.tableView.register(UINib(nibName: HomeCategoryCell.identifire, bundle: nil), forCellReuseIdentifier: HomeCategoryCell.identifire)
        self.tableView.register(UINib(nibName: ItemViewTabCell.identifire, bundle: nil), forCellReuseIdentifier: ItemViewTabCell.identifire)
        
        initViewModel()
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.viewModel.flashBannerResponse?.flash
                details?.forEach({ item in
                    _self.flashArr.append(item)
                })
                
                let storyboard = AdsVC.instantiate(fromAppStoryboard: .Main)
                storyboard.modalPresentationStyle = .overCurrentContext
                storyboard.flashArr = _self.flashArr
                _self.navigationController?.present(storyboard, animated: true)
 
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
        
        viewModel.callFlashBanner()
        
    }
    
    @IBAction func openMenuBtn(_ sender: Any) {
        performSegue(withIdentifier: "showMenu", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

}

extension HomeVC : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = sectionArr[indexPath.section]
        switch index{
        case "search" :
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchCell.identifire, for: indexPath) as! HomeSearchCell
            cell.selectionStyle = .none
            return cell
            
        case "banner":
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerCell.identifire, for: indexPath) as! HomeBannerCell
            cell.selectionStyle = .none
            return cell
            
        case "header":
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleHeaaderCell.identifire, for: indexPath) as! TitleHeaaderCell
            cell.selectionStyle = .none
            cell.titleTxt.text = sectionArr[indexPath.section + 1]
            cell.delegate = self
            cell.header = sectionArr[indexPath.section + 1]
            return cell
            
        case "Main categories":
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeCategoryCell.identifire, for: indexPath) as! HomeCategoryCell
            cell.selectionStyle = .none
            return cell
            
        case "Featured Listing":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.selectionStyle = .none
            return cell

        case "New Listing":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.selectionStyle = .none
            return cell
            
            
        case "Recommendations":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.selectionStyle = .none
            return cell

            
            
        default:
            return UITableViewCell()
        }
    }
    
   
}

extension HomeVC: TitleHeaaderCellDelegate{
    func viewAllAction(header: String) {
        if header == "Main categories"{
            let storyboard = CategoryVC.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
        
        if header == "Featured Listing"{
            let storyboard = ListingVC.instantiate(fromAppStoryboard: .Main)
            storyboard.titleSting = "Featured Listing"
            self.navigationController?.present(storyboard, animated: true)
        }
    }
    
    
}
