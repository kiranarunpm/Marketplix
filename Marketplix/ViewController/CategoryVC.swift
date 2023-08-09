//
//  CategoryVC.swift
//  Marketplix
//
//  Created by Kiran PM on 07/06/23.
//

import UIKit

class CategoryVC: UIViewController {

    
    @IBOutlet weak var colView: UICollectionView!
    var categoryModelArray = [CategoryModel(name: "Car", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Mobile", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Property", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Flat", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Bike", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Cycle", image: "bike-svgrepo-com"),]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colView.delegate = self
        self.colView.dataSource = self
        colView.register(UINib(nibName: CategoryCell.identifire, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifire)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire, for: indexPath) as! CategoryCell
        let index = categoryModelArray[indexPath.row]
        cell.nameTxt.text = index.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = ScreenSize.SCREEN_MAX_LENGTH
        let screen_width = ScreenSize.SCREEN_WIDTH
        if screenSize >= 1024{
            return CGSize(width: screen_width / 6 - 20, height: 60)
        }
        else{
            return CGSize(width: screen_width / 4 - 20, height: 60)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5.0
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5.0
        }
    
    

}
