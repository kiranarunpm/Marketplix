//
//  ListingVC.swift
//  Marketplix
//
//  Created by Kiran PM on 13/06/23.
//

import UIKit
import SkeletonView
import MBProgressHUD
class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
    }
}

enum ListingType: String{
    case newListing = "new_listing"
    case recentlyViewed = "recently_viewed"
    case featuredListing = "featured_listing"
    case recommented = "recommandations"
    case normal
}

class ListingVC: BaseVC {
    var isFormCommonListing: Bool = true
    @IBOutlet weak var noDataView: UIStackView!
    var categoryArr = [Category]()
    @IBOutlet weak var filterBtn: UIButton!
    static let identifire = "ItemViewTabCell"
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    var listingType : ListingType = .normal
    var filterStruct = FilterStruct(category_id: "")

    
    lazy var categoryVM: HomeVM = {
        return HomeVM()
    }()
    
    var dataListArr: [DataList] = []
    
    @IBOutlet weak var title_Txt: UILabel!
    @IBOutlet weak var colView: UICollectionView!
    var titleSting : String?
    lazy var favVM: DetailVM = {
        return DetailVM()
    }()
    var indexPath = IndexPath(row: 0, section: 0)
    var isDonePagination = true
    var page = 1
    var searchString = ""
    @IBOutlet weak var seactTxt: UITextField!
    var category_id: String = ""
    @IBOutlet weak var searchView: R_UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.title_Txt.text = titleSting ?? "Featured Listing"
        colView.register(UINib(nibName: ItemCell.identifire, bundle: nil), forCellWithReuseIdentifier: ItemCell.identifire)
        colView.dataSource = self
        colView.delegate = self
        self.seactTxt.delegate = self

        let screen_width = ScreenSize.SCREEN_WIDTH
        var screenSize = CGSize(width: 0, height: 0)
        if screenSize.height >= 1024{
            screenSize =  CGSize(width: screen_width / 4 - 20, height: 280)
        }
        else{
            screenSize = CGSize(width: screen_width / 2 - 20, height: 280)
        }
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.itemSize = screenSize
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        colView.setCollectionViewLayout(layout1, animated: true)
        colView.reloadData()
        self.seactTxt.text = self.searchString
//        colView.isSkeletonable = true
//        colView.showAnimatedGradientSkeleton(animation: nil, transition: .crossDissolve(0.25))
        
        let lat = User.shared.getSavedData(with: .lat)
        let long = User.shared.getSavedData(with: .long)

        self.filterStruct.lat = lat
        self.filterStruct.log = long
        initViewModel()
        
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            let data = _self.viewModel.classifields
            let total = data?.total ?? 0
            
            self?.dataListArr.append(contentsOf: data?.data ?? [])
            if self?.dataListArr.count == total{
                self?.isDonePagination = true
            }else{
                self?.isDonePagination = false
            }
            
            self?.colView.stopSkeletonAnimation()
            if (self?.dataListArr.count == 0){
                self?.colView.isHidden = true
                self?.noDataView.isHidden = false
            }else{
                self?.colView.isHidden = false
                self?.noDataView.isHidden = true
            }
            self?.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            DispatchQueue.main.async {
                _self.colView.reloadData()
                
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
        
        
        favVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                let data = _self.favVM.successResponse?.message ?? ""

            }
        }
        
        loadList(page: self.page.description)
        
        categoryVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.categoryVM.categoryArr
                _self.categoryArr = details

            }
        }
        
                
        categoryVM.callMainCategory(mainCategory: "")
        
        

    }
    
    func loadList(page: String){
        
        let lat = User.shared.getSavedData(with: .lat)
        let long = User.shared.getSavedData(with: .long)
        
        if listingType == .normal{
            let request = ListRequest(lat: self.filterStruct.lat, lng: self.filterStruct.log, category_id: self.filterStruct.category_id, search: self.searchString, page: self.page.description)
            viewModel.callListing(request)
        }else{
            let request = ListRequest(lat: self.filterStruct.lat, lng: self.filterStruct.log, category_id: self.filterStruct.category_id, search: self.searchString, page: self.page.description, groupType: listingType.rawValue, sortby: SortBy(rawValue: self.filterStruct.sort) ?? .datepublished, price_min: self.filterStruct.price_min, price_max: self.filterStruct.price_max)
            viewModel.callListing(request)

        }
    }
    
    
    @IBAction func back_btn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    func getScreenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }
    
    
    @IBAction func filterActionBtn(_ sender: Any) {
        let storyboard = FilterVC.instantiate(fromAppStoryboard: .Main)
        if #available(iOS 15.0, *) {
            if let presentationController = storyboard.presentationController as? UISheetPresentationController {
                
                presentationController.detents = [.medium()]
            } else {
            }
            storyboard.delegate = self
            storyboard.categoryArr = self.categoryArr
            storyboard.filterStruct = self.filterStruct
            storyboard.modalPresentationStyle = .fullScreen
            self.navigationController?.present(storyboard, animated: true)
        }
    }
}
extension ListingVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return ItemCell.identifire
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataListArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
        let index = dataListArr[indexPath.row]
        cell.indexVal = index
        cell.id = index.id?.description ?? ""
        cell.indexPath = indexPath
        cell.delegete = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = dataListArr[indexPath.row]
        let vc = DetailVC.instantiate(fromAppStoryboard: .Main)
        vc.id = String(index.id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isDonePagination{
            return
        }
        
        let lastItem = self.dataListArr.count - 1
        if indexPath.row == lastItem {
            print("IndexRow\(indexPath.row)")
            self.page += 1
            self.loadList(page: self.page.description)
        }
    }
    
    
}



extension ListingVC: ItemDelegate{
    
    func favActionHander(indexPath: IndexPath, type: String, id: String) {
        if !User.shared.hasToken {
            let vc = LoginVC.instantiate(fromAppStoryboard: .Main)
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(vc, animated: true)
            return
        }
        
        self.indexPath = indexPath
        
        for i in 0...self.dataListArr.count{
            if id == self.dataListArr[i].id?.description ?? ""{
                let fav = self.dataListArr[i].is_fav ?? 0
                if fav == 0{
                    self.dataListArr[i].is_fav = 1
                }else{
                    self.dataListArr[i].is_fav = 0
                }
                self.colView.reloadItems(at: [indexPath])
                
                break
            }
            
        }
        favVM.callAddFav(id)
    }
    
    
}

extension ListingVC: UITextFieldDelegate, FilterStructDelegate{
    func updateFilterAction(filterStruct: FilterStruct) {
        self.filterStruct = filterStruct
        
        self.page = 0
        self.dataListArr.removeAll()
        self.colView.reloadData()
        self.loadList(page: self.page.description)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && range.length == 1 && string == "" {
            self.dataListArr.removeAll()
            self.colView.reloadData()
        }else {
            if range.length == 1 {
                let txt = textField.text!.dropLast()
                self.searchString = String(txt)
                self.page = 0
                self.dataListArr.removeAll()
                self.colView.reloadData()
                
                self.loadList(page: self.page.description)
            }else {
                if let text = textField.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    self.searchString = updatedText
                    self.page = 0
                    self.dataListArr.removeAll()
                    self.colView.reloadData()
                    self.loadList(page: self.page.description)
                }
            }
        }
        return true
    }
}
