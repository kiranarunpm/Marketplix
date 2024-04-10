//
//  ListingVC.swift
//  Marketplix
//
//  Created by Kiran PM on 13/06/23.
//

import UIKit
import MBProgressHUD
class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
    }
}

class ListingVC: UIViewController {
    
    @IBOutlet weak var filterBtn: UIButton!
    static let identifire = "ItemViewTabCell"
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    
    @IBOutlet weak var title_Txt: UILabel!
    @IBOutlet weak var colView: UICollectionView!
    var titleSting : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title_Txt.text = titleSting ?? "Featured Listing"
        colView.register(UINib(nibName: ItemCell.identifire, bundle: nil), forCellWithReuseIdentifier: ItemCell.identifire)
        colView.dataSource = self
        colView.delegate = self
        let screen_width = ScreenSize.SCREEN_WIDTH
        
        var screenSize = CGSize(width: 0, height: 0)
        if screenSize.height >= 1024{
            screenSize =  CGSize(width: screen_width / 4 - 20, height: 250)
        }
        else{
            screenSize = CGSize(width: screen_width / 2 - 20, height: 250)
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
        
        let request = ListRequest()
        viewModel.callListing(request)
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
            storyboard.modalPresentationStyle = .fullScreen
            self.navigationController?.present(storyboard, animated: true)
        }
    }
}
extension ListingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataListArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
        let index = viewModel.dataListArr[indexPath.row]
        cell.indexVal = index
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = viewModel.dataListArr[indexPath.row]
        let vc = DetailVC.instantiate(fromAppStoryboard: .Main)
        vc.id = String(index.id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
}
