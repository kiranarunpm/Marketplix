//
//  CategoryVC.swift
//  Marketplix
//
//  Created by Kiran PM on 07/06/23.
//

import UIKit
import MBProgressHUD
class CategoryVC: UIViewController {

    
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
    var id : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colView.delegate = self
        self.colView.dataSource = self
        colView.register(UINib(nibName: CategoryCell.identifire, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifire)
        
        let screen_width = ScreenSize.SCREEN_WIDTH
        var screenSize = CGSize(width: 0, height: 0)
        if screen_width >= 1024{
            screenSize =  CGSize(width: screen_width / 6 - 20, height: 100)
        }
        else{
            screenSize = CGSize(width: screen_width / 4 - 20, height: 100)
        }
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.itemSize = screenSize
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
        
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        colView.setCollectionViewLayout(layout1, animated: true)
        colView.reloadData()
        initViewModel()
        
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
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
        return viewModel.categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire, for: indexPath) as! CategoryCell
        let index = viewModel.categoryArr[indexPath.row]
        cell.nameTxt.text = index.name
        return cell
    }
    

    
    

}
