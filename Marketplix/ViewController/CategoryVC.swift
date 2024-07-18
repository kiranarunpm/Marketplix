//
//  CategoryVC.swift
//  Marketplix
//
//  Created by Kiran PM on 07/06/23.
//

import UIKit
import MBProgressHUD
class CategoryVC: BaseVC {

    
    @IBOutlet weak var noDataView: UIStackView!
    @IBOutlet weak var colView: UICollectionView!
    var categoryModelArray = [CategoryModel(name: "Car", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Mobile", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Property", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Flat", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Bike", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Cycle", image: "bike-svgrepo-com"),]
    
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    @IBOutlet weak var seactTxt: UITextField!
    var categoryArr =  [Category]()
    var tempCategoryArr = [Category]()
    var id : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seactTxt.delegate = self
        self.colView.delegate = self
        self.colView.dataSource = self
        colView.register(UINib(nibName: CategoryCell.identifire, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifire)
        
        let screen_width = ScreenSize.SCREEN_WIDTH
        var screenSize = CGSize(width: 0, height: 0)
        if screen_width >= 1024{
            screenSize =  CGSize(width: screen_width / 6 - 20, height: 100)
        }
        else{
            screenSize = CGSize(width: screen_width / 3 - 0, height: 200)
        }
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.itemSize = screenSize
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout1.minimumLineSpacing = 0
        layout1.minimumInteritemSpacing = 0
        colView.setCollectionViewLayout(layout1, animated: true)
        colView.reloadData()
        initViewModel()
        
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            let categoryArr = _self.viewModel.categoryArr
            _self.categoryArr = categoryArr
            _self.tempCategoryArr = categoryArr
            if categoryArr.isEmpty{
                self?.colView.isHidden = true
                _self.noDataView.isHidden = false
            }
            else{
               
                self?.colView.isHidden = false
                _self.noDataView.isHidden = true

            }
            
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
        
        viewModel.callCategory("\(id)")
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempCategoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire, for: indexPath) as! CategoryCell
        let index = tempCategoryArr[indexPath.row]
        cell.nameTxt.text = index.name
        let url = index.image_url ?? ""
        cell.nameTxt.font = .MPfont(.medium, size: 15)
        cell.nameTxt.numberOfLines = 3
        if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            let url = URL(string: urlString)
            cell.img.kf.setImage(with: url,options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage
            ])
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = tempCategoryArr[indexPath.row]

        let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
        var filterStruct = FilterStruct(category_id: "")
        vc.filterStruct.category_id = index.id?.description ?? ""
        vc.titleSting = index.name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension CategoryVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && range.length == 1 && string == "" {
            self.tempCategoryArr.removeAll()
            self.tempCategoryArr = categoryArr
            self.colView.reloadData()
        }else {
            if range.length == 1 {
                let txt = textField.text!.dropLast()
                self.tempCategoryArr = categoryArr.filter() { $0.name?.contains(txt) ?? false }
                self.colView.reloadData()
                
            }else {
                if let text = textField.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    self.tempCategoryArr = categoryArr.filter() { $0.name?.lowercased().contains(updatedText) ?? false }
                    self.colView.reloadData()
                }
            }
        }
        return true
    }
}
