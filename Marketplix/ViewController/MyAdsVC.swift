//
//  MyAdsVC.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit
import MBProgressHUD
class MyAdsVC: UIViewController {
    lazy var viewModel: PostAdsVM = {
        return PostAdsVM()
    }()
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
        let vc = PostAdsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated:    true)
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
        
        viewModel.callMyAds()
    }
    
}

extension MyAdsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listItemResponse?.classifields?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNewItems.identifire, for: indexPath) as! HomeNewItems
        let index = viewModel.listItemResponse?.classifields?.data?[indexPath.row]
        if let url = index?.classified_images?.first?.image_url{
            if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                let url = URL(string: urlString)
                cell.img.kf.setImage(with: url, placeholder: UIImage(named: "no-image"))
                cell.img.contentMode = .scaleAspectFit
            }
        }
       
        cell.name.text = index?.title ?? ""
        cell.descriptions.text = index?.description ?? ""
        cell.price.text = "₹\(index?.price ?? "")"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = viewModel.listItemResponse?.classifields?.data?[indexPath.row]
        let vc = DetailVC.instantiate(fromAppStoryboard: .Main)
        vc.id = String(index?.id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
}


