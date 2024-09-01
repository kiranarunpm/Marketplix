//
//  MyAdsVC.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit
import MBProgressHUD
class MyAdsVC: BaseVC {
    lazy var viewModel: PostAdsVM = {
        return PostAdsVM()
    }()
    var dataList = [DataList]()
    lazy var getPostValues: PostAdsVM = {
        return PostAdsVM()
    }()
    
    lazy var postAdStatusUpdate: DetailVM = {
        return DetailVM()
    }()
    
    
    var postRealEstateArr  = [PostRealEstateModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()

    }
    @IBOutlet weak var colView: UICollectionView!{
        didSet{
            colView.delegate = self
            colView.dataSource = self
            colView.register(UINib(nibName: HomeNewItems.identifire, bundle: nil), forCellWithReuseIdentifier: HomeNewItems.identifire)
            let screen_width = ScreenSize.SCREEN_WIDTH

            var screenSize = CGSize(width: screen_width - 10, height: 130)
           
            let layout1 = UICollectionViewFlowLayout()
            layout1.scrollDirection = .vertical
            layout1.itemSize = screenSize
            layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout1.scrollDirection = .vertical
            layout1.minimumLineSpacing = 10
            layout1.minimumInteritemSpacing = 10
            colView.setCollectionViewLayout(layout1, animated: true)
            colView.reloadData()
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    @IBAction func postAdsVC(_ sender: Any) {
        self.navigationController?.tabBarController?.selectedIndex = 2
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        
        getPostValues.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let data = _self.getPostValues.postRealEstateArr
                _self.postRealEstateArr = data
                
                
            }
        }
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            let data = _self.viewModel.listItemResponse?.classifields?.data ?? []
            self?.dataList = data.filter({ item in
                return Int(item.status?.description ?? "0") == 1 || Int(item.status?.description ?? "0") == 0
            })
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
        
        postAdStatusUpdate.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let data = _self.postAdStatusUpdate.subscriptionResponse
                self?.showToastLogIn(message: data?.message ?? "")
                _self.viewModel.callMyAds()


            }
        }
        
        viewModel.callMyAds()
        getPostValues.callPostValues()

    }
    
}

extension MyAdsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNewItems.identifire, for: indexPath) as! HomeNewItems
        let index = self.dataList[indexPath.row]
        cell.dataList = index
        if let url = index.classified_images?.first?.image_url{
            if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                let url = URL(string: urlString)
                cell.img.kf.setImage(with: url, placeholder: UIImage(named: "no-image"))
                cell.img.contentMode = .scaleAspectFit
            }
        }
        let status = Int(index.status?.description ?? "0")
        if status == 2{
            cell.soldOutImg.isHidden = false
        }else{
            cell.soldOutImg.isHidden = true
        }
        if status == 0{
            cell.waitingView.isHidden = false
        }else{
            cell.waitingView.isHidden = true
        }
        cell.name.text = index.title ?? ""
        cell.descriptions.text = index.addresses?.sector ?? ""
        cell.createdAtLbl.text = "Posted on: \(index.time_diff ?? "1 day ago")"
        cell.categoryLbl.text = "\(index.category?.name ?? "")"
        let price : Double = Double(index.price ?? "") ?? 0
        cell.price.text = Constants.currencySymbol + "\(price.roundedDecimal(to: 0))"
        cell.distanceStack.isHidden = true
        cell.favBtn.isHidden = true
        cell.delegete = self
        cell.menuOptionsBtn.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.dataList[indexPath.row]
        if Int(index.status?.description ?? "0") == 2 || Int(index.status?.description ?? "0") == 0{
            return
        }
        let vc = DetailVC.instantiate(fromAppStoryboard: .Main)
        vc.id = index.id?.description ?? ""
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
}


extension MyAdsVC: HomeNewItemsDelegate{
    func editAction(dataList: DataList?) {
        let vc = PostAdsVC.instantiate(fromAppStoryboard: .Main)
        vc.editData = dataList
        vc.isOnEdit = true
        var i = 0
        self.postRealEstateArr.forEach { item in
            item.results?.forEach({ content in
                if content.name == "Category"{
                    self.postRealEstateArr[0].results?[i].value = dataList?.category_id?.description ?? ""
                 }
                 
                 i += 1
            })
         
        }
        vc.postRealEstateArr = self.postRealEstateArr
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func favActionHander(indexPath: IndexPath, type: String, id: String) {
        
    }

    
    func deleteAction(dataList: DataList?) {
        let alert = UIAlertController(title: "Delete Ad", message: "Do you want to delete your Ad?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                self.postAdStatusUpdate.callAdStatusUpdate(dataList?.id?.description ?? "", "4")
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default: break
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func closeAction(dataList: DataList?){
        let alert = UIAlertController(title: "SOLD OUT?", message: "Do you want to change the status as Sold Out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                self.postAdStatusUpdate.callAdStatusUpdate(dataList?.id?.description ?? "", "2")
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default: break
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
}
