//
//  HomeCategoryCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit
struct CategoryModel{
    let name: String
    let image: String
}

protocol HomeCategoryCellDelegate {

}
class HomeCategoryCell: UITableViewCell {
    static let identifire = "HomeCategoryCell"
    var categoryModelArray = [CategoryModel(name: "Car", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Mobile", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Property", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Flat", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Bike", image: "bike-svgrepo-com"),
                              CategoryModel(name: "Cycle", image: "bike-svgrepo-com"),]
    @IBOutlet weak var categoryColView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
                categoryColView.register(UINib(nibName: CategoryCell.identifire, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifire)
                categoryColView.dataSource = self
                categoryColView.delegate = self
                
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func getScreenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }


    
}

extension HomeCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            return CGSize(width: screen_width / 6 - 20, height: 100)
        }
        else{
            return CGSize(width: screen_width / 5 - 20, height: 100)
        }
    }
    
    
    

}
