//
//  FavouriteVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit
import MBProgressHUD
class FavouriteVC: BaseVC {
    @IBOutlet weak var colView: UICollectionView!
    static let identifire = "ItemViewTabCell"
    lazy var viewModel: DetailVM = {
        return DetailVM()
    }()
    lazy var favVM: DetailVM = {
        return DetailVM()
    }()
    @IBOutlet weak var dataStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colView.register(UINib(nibName: ItemCell.identifire, bundle: nil), forCellWithReuseIdentifier: ItemCell.identifire)
        colView.dataSource = self
        colView.delegate = self
        let screen_width = ScreenSize.SCREEN_WIDTH

        var screenSize = CGSize(width: 0, height: 0)
        if screenSize.height >= 1024{
            screenSize =  CGSize(width: screen_width / 4 - 20, height: 270)
        }
        else{
            screenSize = CGSize(width: screen_width / 2 - 20, height: 280)
        }
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.itemSize = screenSize
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
        
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        colView.setCollectionViewLayout(layout1, animated: true)
        colView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewModel()

    }
    
    // MARK: InitViewModel
    func initViewModel() {
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                _self.colView.reloadData()
                let dataListArr = _self.viewModel.dataListArr
                if dataListArr.isEmpty{
                    _self.colView.isHidden = true
                    _self.dataStack.isHidden = false
                }else{
                    _self.colView.isHidden = false
                    _self.dataStack.isHidden = true


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
                self?.colView.reloadData()
                _self.viewModel.callListingFav()

            }
        }
        
        viewModel.callListingFav()
    }

}

extension FavouriteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataListArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
        let index = viewModel.dataListArr[indexPath.row]
        cell.indexVal = index
        cell.id = index.id?.description ?? "0"
        cell.favImg.setImage(UIImage(named: "favorite-filled"), for: .normal)
        cell.delegete = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = viewModel.dataListArr[indexPath.row]
        let vc = DetailVC.instantiate(fromAppStoryboard: .Main)
        vc.id = String(index.id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}
extension FavouriteVC: ItemDelegate{
    func favActionHander(indexPath: IndexPath, type: String, id: String) {
        favVM.callAddFav(id)
    }
    
    
}
