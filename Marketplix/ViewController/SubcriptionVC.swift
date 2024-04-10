//
//  SubcriptionVC.swift
//  Marketplix
//
//  Created by Kiran on 08/10/23.
//

import UIKit
import MBProgressHUD
class SubcriptionVC: UIViewController {
    @IBOutlet weak var colView: UICollectionView!
    lazy var viewModel: DetailVM = {
        return DetailVM()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        colView.delegate = self
        colView.dataSource = self
        colView.register(UINib(nibName: SubscriptionPlanCell.identifire, bundle: nil), forCellWithReuseIdentifier: SubscriptionPlanCell.identifire)
        
        self.colView.showsHorizontalScrollIndicator = false
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 100, height: colView.frame.height - 100)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 0.8
        floawLayout.sideItemAlpha = 0.6
        floawLayout.spacingMode = .overlap(visibleOffset: 100)
        colView.collectionViewLayout = floawLayout
        colView.reloadData()
        initViewModel()
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
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
        
        viewModel.callSubsriptionList()
    }

}

extension SubcriptionVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.subscriptionResponse?.subscription_plans?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionPlanCell.identifire, for: indexPath) as! SubscriptionPlanCell
        let index = self.viewModel.subscriptionResponse?.subscription_plans?[indexPath.row]
        cell.indexValue = index
        return cell
    }
    
    

    
}
