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
    var sectionArr = ["banner", "header","Main categories"]
    
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
            
            let featured_listing = _self.dashboardVM.dashboardResponse?.featured_listing ?? []
            if !featured_listing.isEmpty{
                _self.sectionArr.append("header")
                _self.sectionArr.append("Featured Listing")
            }
            
            let new_listing = _self.dashboardVM.dashboardResponse?.new_listing ?? []
            if !new_listing.isEmpty{
                _self.sectionArr.append("header")
                _self.sectionArr.append("New Listing")
            }
            
            let recommandation = _self.dashboardVM.dashboardResponse?.recommandation ?? []
            if !recommandation.isEmpty{
                _self.sectionArr.append("header")
                _self.sectionArr.append("Recommendations")
            }
            
            let recently_viewed = _self.dashboardVM.dashboardResponse?.recently_viewed ?? []
            if !recently_viewed.isEmpty{
                _self.sectionArr.append("header")
                _self.sectionArr.append("Recently Viewed")
            }

            DispatchQueue.main.async {
                
                _self.tableView.reloadData()
                
            }
        }
        
        viewModel.callFlashBanner()
        categoryVM.callMainCategory(mainCategory: "")
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
            let data = dashboardVM.dashboardResponse?.banner1?.map({ item in
                return item.image_url ?? ""
            })
            cell.loadBannerImage(image: data ?? [])
            cell.selectionStyle = .none
            return cell
            
        case "header":
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleHeaaderCell.identifire, for: indexPath) as! TitleHeaaderCell
            cell.selectionStyle = .none
            let index = sectionArr[indexPath.section + 1]
            cell.titleTxt.text = index
            cell.delegate = self
            cell.header = sectionArr[indexPath.section + 1]
            cell.seeMoreBtn.isHidden = index == "Main categories" ? true : false
            
            return cell
            
        case "Main categories":
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeCategoryCell.identifire, for: indexPath) as! HomeCategoryCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.categoryArr = dashboardVM.dashboardResponse?.main_categories ?? []
            cell.reloadData()
            return cell
            
        case "Featured Listing":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.type = "Featured Listing"
            cell.featuredListingArr = dashboardVM.dashboardResponse?.featured_listing ?? []
            cell.reloadData()
            return cell
            
        case "New Listing":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.type = "New Listing"
            cell.delegate = self
            cell.new_listing = dashboardVM.dashboardResponse?.new_listing ?? []
            cell.selectionStyle = .none
            return cell
            
            
        case "Recommendations":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.type = "Recommendations"
            cell.delegate = self
            cell.recommendationArr = dashboardVM.dashboardResponse?.recommandation ?? []
            cell.selectionStyle = .none
            cell.reloadData()
            return cell
            
        case "Recently Viewed":
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewTabCell.identifire, for: indexPath) as! ItemViewTabCell
            cell.type = "Recently Viewed"
            cell.delegate = self
            cell.recentlyViewArr = dashboardVM.dashboardResponse?.recently_viewed ?? []
            cell.selectionStyle = .none
            cell.reloadData()
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
        
        if header == "New Listing"{
            let storyboard = ListingVC.instantiate(fromAppStoryboard: .Main)
            storyboard.titleSting = "New Listing"
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
        
        if header == "Recommendations"{
            let storyboard = ListingVC.instantiate(fromAppStoryboard: .Main)
            storyboard.titleSting = "Recommendations"
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
        
        if header == "Recently Viewed"{
            let storyboard = ListingVC.instantiate(fromAppStoryboard: .Main)
            storyboard.titleSting = "Recently Viewed"
            self.navigationController?.pushViewController(storyboard, animated: true)
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
    
    func toDetail(_ id: Int) {
        let vc = DetailVC.instantiate(fromAppStoryboard: .Main)
        vc.id = String(id)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
}

extension HomeVC : HomeCategoryCellDelegate, ItemViewTabDelegate{
    func callSubCategory(id: Int) {
        let vc = CategoryVC.instantiate(fromAppStoryboard: .Main)
        vc.id  = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
