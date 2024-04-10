//
//  PostPropertyVC.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import UIKit
import MBProgressHUD
class PostPropertyVC: BaseVC {

    var categoryArr = [Category]()
    var selectedIndex : Int = -1
    var selectedCategoryIndex : Int = -1

    var postRealEstateArr  = [PostRealEstateModel]()
    lazy var getPostValues: PostAdsVM = {
        return PostAdsVM()
    }()
    @IBOutlet weak var selectCatTxt: MPUILabel!
    
    @IBOutlet weak var colView: UICollectionView!{
        didSet{
            self.colView.delegate = self
            self.colView.dataSource = self
            self.colView.register(UINib(nibName: PostMainCatColCell.identifire, bundle: nil), forCellWithReuseIdentifier: PostMainCatColCell.identifire)
            
            
            let screenSize = CGSize(width: 100, height: 100)
            let layout1 = UICollectionViewFlowLayout()
            layout1.scrollDirection = .horizontal
            layout1.itemSize = screenSize
            layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
            
            layout1.minimumLineSpacing = 15
            layout1.minimumInteritemSpacing = 0
            colView.setCollectionViewLayout(layout1, animated: true)
            colView.reloadData()
        }
    }
    
    @IBOutlet weak var colView2: UICollectionView!{
        didSet{
            self.colView2.delegate = self
            self.colView2.dataSource = self
            self.colView2.register(UINib(nibName: PostMainCatColCell.identifire, bundle: nil), forCellWithReuseIdentifier: PostMainCatColCell.identifire)
            
            
            let screenSize = CGSize(width: 100, height: 100)
            let layout1 = UICollectionViewFlowLayout()
            layout1.scrollDirection = .horizontal
            layout1.itemSize = screenSize
            layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:15)
            
            layout1.minimumLineSpacing = 15
            layout1.minimumInteritemSpacing = 0
            colView2.setCollectionViewLayout(layout1, animated: true)
            colView2.reloadData()
        }
    }

    
    lazy var categoryVM: HomeVM = {
        return HomeVM()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()

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
        
       
        categoryVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.categoryVM.categoryArr
                _self.categoryArr = details
                
                _self.colView.reloadData()
                
            }
        }
        categoryVM.loadingStatus = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let isLoading = _self.categoryVM.isLoading ?? false
                
                if isLoading {
                    MBProgressHUD.showAdded(to: _self.view, animated: true)
                    
                }else {
                    MBProgressHUD.hide(for: _self.view, animated: true)
                }
            }
        }

        categoryVM.callMainCategory(mainCategory: "")
        getPostValues.callPostValues()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PostPropertyVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colView{
            return self.categoryArr.count
        }else{
            if selectedIndex != -1{
                return self.categoryArr[selectedIndex].sub_category?.count ?? 0
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostMainCatColCell.identifire, for: indexPath) as! PostMainCatColCell
            let index = categoryArr[indexPath.row]
            cell.lbl.text = index.name
            let image = index.image_url ?? ""
            cell.loadImage(url: image)
            if selectedIndex == indexPath.row{
                cell.tick.isHidden = false
            }else{
                cell.tick.isHidden = true

            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostMainCatColCell.identifire, for: indexPath) as! PostMainCatColCell
            let index = self.categoryArr[selectedIndex].sub_category?[indexPath.row]
            cell.lbl.text = index?.name
            let image = index?.image_url ?? ""
            cell.loadImage(url: image)
            if selectedCategoryIndex == indexPath.row{
                cell.tick.isHidden = false
            }else{
                cell.tick.isHidden = true

            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colView{
            self.selectedIndex = indexPath.row
            selectCatTxt.isHidden = false
            self.colView.reloadData()
            
            self.colView2.reloadData()
        }
        else{
            var i = 0
            selectedCategoryIndex = indexPath.row
            self.colView2.reloadData()
            let inex = self.categoryArr[selectedIndex].sub_category?[indexPath.row]
            self.postRealEstateArr.forEach { item in
                item.results?.forEach({ content in
                    if content.name == "Category"{
                        self.postRealEstateArr[0].results?[i].value = inex?.id?.description ?? ""
                     }
                     
                     i += 1
                })
             
            }
            
            let storyboard = PostAdsVC.instantiate(fromAppStoryboard: .Main)
            storyboard.postRealEstateArr = self.postRealEstateArr
            self.navigationController?.pushViewController(storyboard, animated: true)
            
        }
    }
    
    
}
