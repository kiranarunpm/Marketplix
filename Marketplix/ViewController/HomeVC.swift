//
//  HomeVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit
import ImageSlideshow
import MBProgressHUD


class HomeVC: BaseVC, UIViewControllerTransitioningDelegate {
    
    let names = ["Searh Land", "Search Property", "Search Car", "Search Laptops"]
    let sectionArr = ["banner", "header","Main categories", "header", "Featured Listing", "header", "New Listing", "header", "Recommendations"]
    
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    
    lazy var categoryVM: HomeVM = {
        return HomeVM()
    }()
    lazy var dashboardVM: HomeVM = {
        return HomeVM()
    }()
    var flashArr = [Flash]()
    @IBOutlet weak var wishesTxt: MPUILabel!
    
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
        
        
        tableView.register(UINib(nibName: "SearchHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SearchHeaderView")
        setupUI()
        initViewModel()
    }
    
    func setupUI(){
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12 : self.wishesTxt.text = "Good Morning"
        case 12..<17 : self.wishesTxt.text = "Good Afternoon"
        case 17..<22 : self.wishesTxt.text = "Good Evening"
        default: self.wishesTxt.text = "Good Evening"
        }
        
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
        
        categoryVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.categoryVM.categoryArr
                _self.tableView.reloadData()
                
            }
        }
        dashboardVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                _self.tableView.reloadData()
                
            }
        }
        
        viewModel.callFlashBanner()
        categoryVM.callMainCategory(mainCategory: "1")
        dashboardVM.callDashboard()
        
    }
    
    @IBAction func openMenuBtn(_ sender: Any) {
        performSegue(withIdentifier: "showMenu", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    @IBAction func getLocationBtn(_ sender: Any) {
        let vc = LocationPickVC.instantiate(fromAppStoryboard: .Main)
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
}

extension HomeVC : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.sectionArr[indexPath.section] == "New Listing"{
            return 140
        }
        return UITableView.automaticDimension
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
            cell.categoryArr = categoryVM.categoryArr
            cell.reloadData()
            return cell
            
        case "Featured Listing":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.selectionStyle = .none
            return cell
            
        case "New Listing":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.type = "New Listing"
            cell.new_listing = dashboardVM.dashboardResponse?.new_listing ?? []
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
            storyboard.modalPresentationStyle = .currentContext
            if #available(iOS 15.0, *) {
                if let presentationController = storyboard.presentationController as? UISheetPresentationController {
                    
                    presentationController.detents = [.medium(),.large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
                    ///
                }
            } else {
                // Fallback on earlier versions
            }
            self.navigationController?.present(storyboard, animated: true)
        }
    }
    
    
}




extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


extension HomeVC: LocationPickDelegate{
    func getLocation(_ location: String) {
        print("Location ", location)
    }
    
    
}
