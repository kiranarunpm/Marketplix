//
//  HomeVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit
import ImageSlideshow
import MBProgressHUD
import SkeletonView
import Hero
import DropDown
class HomeVC: BaseVC, UIViewControllerTransitioningDelegate {
    
    let names = ["Searh Land", "Search Property", "Search Car", "Search Laptops"]
    var sectionArr = ["header","Main categories"]
    var commonWordsArr = [String]()
    var tempCommonWordsArr = [String]()
    
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    
    @IBOutlet weak var dropView: DropDown!
    lazy var commonWords: PostAdsVM = {
        return PostAdsVM()
    }()
    let dropDown = DropDown()
    
    
    @IBOutlet weak var locationView: R_UIView!
    lazy var categoryVM: HomeVM = {
        return HomeVM()
    }()
    lazy var dashboardVM: HomeVM = {
        return HomeVM()
    }()
    lazy var updateTokenVM: HomeVM = {
        return HomeVM()
    }()
    lazy var versionVM: HomeVM = {
        return HomeVM()
    }()
    var flashArr = [Flash]()
    @IBOutlet weak var wishesTxt: MPUILabel!
    
    @IBOutlet weak var nameTxt: MPUILabel!
    @IBOutlet weak var tableView: UITableView!
    lazy var favVM: DetailVM = {
        return DetailVM()
    }()
    var indexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var locationTxt: UIButton!
    
    @IBOutlet weak var searchView: R_UIView!
    @IBOutlet weak var searchTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTxt.delegate = self
        let timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLocation(_:)), name: NSNotification.Name(rawValue: "updateLocation"), object: nil)
        
        self.locationView.layer.cornerRadius = 20
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: HomeSearchCell.identifire, bundle: nil), forCellReuseIdentifier: HomeSearchCell.identifire)
        self.tableView.register(UINib(nibName: HomeBannerCell.identifire, bundle: nil), forCellReuseIdentifier: HomeBannerCell.identifire)
        self.tableView.register(UINib(nibName: TitleHeaaderCell.identifire, bundle: nil), forCellReuseIdentifier: TitleHeaaderCell.identifire)
        self.tableView.register(UINib(nibName: HomeCategoryCell.identifire, bundle: nil), forCellReuseIdentifier: HomeCategoryCell.identifire)
        self.tableView.register(UINib(nibName: ItemViewTabCell.identifire, bundle: nil), forCellReuseIdentifier: ItemViewTabCell.identifire)
        self.tableView.register(UINib(nibName: NewListingBaseTabCell.identifire, bundle: nil), forCellReuseIdentifier: NewListingBaseTabCell.identifire)
        
        let name = User.shared.getSavedData(with: .name)
        nameTxt.text = name == "" ? "Guest" : name
        self.searchTxt.delegate = self
        tableView.register(UINib(nibName: "SearchHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SearchHeaderView")
        setupUI()
        initViewModel()
        
        self.searchView.hero.modifiers = [.translate(y:100)]
        
        tableView.isSkeletonable = true
        
        tableView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .skeletonDefault), transition : .crossDissolve(0.5))
        
        dropDown.anchorView = dropView // UIView or UIBarButtonItem
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.searchTxt.text = item
            
        }
        
        searchTxt.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        let loc = User.shared.getSavedData(with: .location)
        self.locationTxt.setTitle(loc  == "" ? "Bengaluru" : loc , for: .normal)

        
        
        
        
    }
    @objc func doneButtonClicked(_ sender: Any) {
        let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
        vc.searchString  = self.searchTxt.text ?? ""
        vc.titleSting  = self.searchTxt.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func timerAction() {
        if let randomValue = names.randomElement() {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
                self.searchTxt.placeholder = randomValue
                self.view.layoutIfNeeded()
            }
        } else {
            
        }
    }
    
    
    @objc func updateLocation(_ no: NSNotification){
        sectionArr.removeAll()
        self.sectionArr = ["header","Main categories"]
        self.flashArr.removeAll()
        self.tableView.reloadData()
        let loc = User.shared.getSavedData(with: .location)
        self.locationTxt.setTitle(loc  == "" ? "Bengaluru" : loc , for: .normal)
        
        let lat = User.shared.getSavedData(with: .lat)
        let lng = User.shared.getSavedData(with: .long)
        dashboardVM.callDashboard(lat: lat == "" ? "12.956467" : lat, lng: lng == "" ? "77.597915" : lng)
        
    }
    
    
    
    func setupUI(){
        if User.shared.getSavedData(with: .location) != ""{
            self.locationTxt.setTitle(User.shared.getSavedData(with: .location).capitalized, for: .normal)
        }
        
        
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
                
                if !_self.flashArr.isEmpty {
                    let vc = AdsVC.instantiate(fromAppStoryboard: .Main)
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.flashArr = _self.flashArr
                    vc.delegate = self
                    _self.navigationController?.present(vc, animated: true)
                    
                }
                
                
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
                    //                    MBProgressHUD.showAdded(to: _self.view, animated: true)
                    
                }else {
                    //                    MBProgressHUD.hide(for: _self.view, animated: true)
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
            _self.sectionArr.append("banner")

            
            let recently_viewed = _self.dashboardVM.dashboardResponse?.recently_viewed ?? []
            if !recently_viewed.isEmpty{
                _self.sectionArr.append("header")
                _self.sectionArr.append("Recently Viewed")
            }
            
            
            self?.tableView.stopSkeletonAnimation()
            self?.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            
            let chatCount = _self.dashboardVM.dashboardResponse?.chat_count ?? 0
            if let tabItems = _self.tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[3]
                if chatCount > 0{
                    tabItem.badgeValue = "\(chatCount)"
                }else{
                    tabItem.badgeValue = nil
                }

            }
            
            DispatchQueue.main.async {
                
                _self.tableView.reloadData()
                
            }
        }
        
        favVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                let data = _self.favVM.successResponse?.message ?? ""
                self?.showToastLogIn(message: data, tobottom: 70)
            }
        }
        
        
        updateTokenVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.updateTokenVM.categoryArr
                _self.tableView.reloadData()
                
            }
        }
        
        
        versionVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.versionVM.versionResponse?.versions?.first
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                let mandatory = details?.mandatory ?? 0
                if Double(appVersion ?? "1") ?? 0 > (details?.version ?? 0){
                    let vc = UpdateAvailableVC.instantiate(fromAppStoryboard: .Main)
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.skipisActive = mandatory == 0 ? false : true
                    self?.navigationController?.present(vc, animated: true)
                }
                
                
            }
        }
        
        
        versionVM.callVersionUpdate("ios")
        
        commonWords.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                let data = _self.commonWords.commonWordArray ?? []
                self?.commonWordsArr = data
                self?.tableView.reloadData()
            }
        }
        
        commonWords.callCommonWords()
        
        
        viewModel.callFlashBanner()
        categoryVM.callMainCategory(mainCategory: "")
        
        let lat = User.shared.getSavedData(with: .lat)
        let lng = User.shared.getSavedData(with: .long)
        
        dashboardVM.callDashboard(lat: lat == "" ? "12.956467" : lat, lng: lng == "" ? "77.597915" : lng)
        
        updateTokenVM.callUpdatetoken(User.shared.getSavedData(with: .fcmToken))
        
        
    }
    
    @IBAction func openMenuBtn(_ sender: Any) {
        performSegue(withIdentifier: "showMenu", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let value = User.shared.getSavedData(with: .isEnableAllowAccess)
        if value != "true"{
            let vc = AllowAccessVC.instantiate(fromAppStoryboard: .Main)
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(vc, animated: true)
        }
        
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    @IBAction func getLocationBtn(_ sender: Any) {
        let vc = LocationPickVC.instantiate(fromAppStoryboard: .Main)
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
        vc.searchString  = self.searchTxt.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.searchTxt.text = ""
        self.dropDown.hide()
        view.endEditing(true)
    }
    
    func containtWords(word: String){
        let predicate = NSPredicate(format: "SELF contains %@", word)
        let searchDataSource = commonWordsArr.filter { predicate.evaluate(with: $0) }
        self.dropDown.dataSource = searchDataSource
        if searchDataSource.count <= 0{
            self.dropDown.hide()
        }else{
            self.dropDown.show()
            
        }
    }
}

extension HomeVC : UITableViewDelegate, SkeletonTableViewDataSource{
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if indexPath.row == 5{
            return HomeBannerCell.identifire
        }else if indexPath.row == 0{
            return HomeCategoryCell.identifire
        }else if indexPath.row == 1{
            return TitleHeaaderCell.identifire
        }
        else{
            return ItemViewTabCell.identifire
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.sectionArr[indexPath.section] == "New Listing"{
            return 150
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
            
            cell.reloadData()
            return cell
            
        case "New Listing":
            let cell = tableView.dequeueReusableCell(withIdentifier: NewListingBaseTabCell.identifire, for: indexPath) as! NewListingBaseTabCell
            cell.delegate = self
            cell.type = "New Listing"
            cell.new_listing = dashboardVM.dashboardResponse?.new_listing ?? []
            cell.selectionStyle = .none
            cell.reloadData()
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
    func getLocation(_ location: String, lat: String, lng: String) {
        print(location)
        self.locationTxt.setTitle(location, for: .normal)
        
        User.shared.saveData(with: .location, value: location)
        User.shared.saveData(with: .lat, value: lat)
        User.shared.saveData(with: .long, value: lng)
        
        sectionArr.removeAll()
        self.sectionArr = ["header","Main categories"]
        self.flashArr.removeAll()
        self.tableView.reloadData()
        
        
        dashboardVM.callDashboard(lat: lat, lng: lng)
        
        
        
    }
    
    
    
    func toDetail(_ id: Int, distance: String) {
        let vc = DetailVC.instantiate(fromAppStoryboard: .Main)
        vc.id = String(id)
        vc.distance = distance
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

extension HomeVC : HomeCategoryCellDelegate, ItemViewTabDelegate, NewListingBaseTabCellDelegate{
    func toDetail(_ id: Int) {
        
    }
    
    
    
    func favActionHander(indexPath: IndexPath, type: String, id: String) {
        self.indexPath = indexPath
        if type == "New Listing"{
            let new_listing = dashboardVM.dashboardResponse?.new_listing ?? []
            for i in 0...new_listing.count - 1{
                if Int(id) == dashboardVM.dashboardResponse?.new_listing?[i].id{
                    let fav = dashboardVM.dashboardResponse?.new_listing?[i].is_fav
                    dashboardVM.dashboardResponse?.new_listing?[i].is_fav = fav == 0 ? 1 : 0
                    break
                }
            }
        }
        if type == "Featured Listing"{
            let featured_listing = dashboardVM.dashboardResponse?.featured_listing ?? []
            for i in 0...featured_listing.count - 1{
                if Int(id) == dashboardVM.dashboardResponse?.featured_listing?[i].id{
                    let fav = dashboardVM.dashboardResponse?.featured_listing?[i].is_fav
                    dashboardVM.dashboardResponse?.featured_listing?[i].is_fav = fav == 0 ? 1 : 0
                    break
                }
            }
            
        }else if type == "Recommendations"{
            let recommandation = dashboardVM.dashboardResponse?.recommandation ?? []
            for i in 0...recommandation.count - 1{
                if Int(id) == dashboardVM.dashboardResponse?.recommandation?[i].id{
                    let fav = dashboardVM.dashboardResponse?.recommandation?[i].is_fav
                    dashboardVM.dashboardResponse?.recommandation?[i].is_fav = fav == 0 ? 1 : 0
                    break
                }
            }
        }else if type == "Recently Viewed"{
            let recommandation = dashboardVM.dashboardResponse?.recently_viewed ?? []
            for i in 0...recommandation.count - 1{
                if Int(id) == dashboardVM.dashboardResponse?.recently_viewed?[i].id{
                    let fav = dashboardVM.dashboardResponse?.recently_viewed?[i].is_fav
                    dashboardVM.dashboardResponse?.recently_viewed?[i].is_fav = fav == 0 ? 1 : 0
                    break
                }
            }
        }
        self.tableView.reloadData()
        favVM.callAddFav(id)
        
    }
    
    func callSubCategory(id: Int) {
        let vc = CategoryVC.instantiate(fromAppStoryboard: .Main)
        vc.id  = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension HomeVC: UITextFieldDelegate, AdsDelegate{
    func openReportView() {
        let vc = ReportAdVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.id = "7"
        self.navigationController?.present(vc, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && range.length == 1 && string == "" {
            self.tempCommonWordsArr.removeAll()
            self.dropDown.hide()
            
        }else {
            if range.length == 1 {
                let txt = textField.text!.dropLast()
                self.containtWords(word: String(txt))
            }else {
                if let text = textField.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    self.containtWords(word: String(updatedText))
                    
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
        vc.searchString  = self.searchTxt.text ?? ""
        vc.titleSting  = self.searchTxt.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        return true
    }
}


