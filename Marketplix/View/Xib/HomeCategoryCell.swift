//
//  HomeCategoryCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit
import Kingfisher
import SkeletonView
struct CategoryModel{
    let name: String
    let image: String
}

protocol HomeCategoryCellDelegate {
    func callSubCategory(id: Int)
}
class HomeCategoryCell: UITableViewCell {
    static let identifire = "HomeCategoryCell"
    var categoryArr =  [Category]()
    var delegate: HomeCategoryCellDelegate?
    @IBOutlet weak var categoryColView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
                categoryColView.register(UINib(nibName: CategoryCell.identifire, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifire)
                categoryColView.dataSource = self
                categoryColView.delegate = self
                
//        categoryColView.isSkeletonable = true
//        categoryColView.showAnimatedGradientSkeleton(animation: nil, transition: .crossDissolve(0.25))
        
        let screen_width = ScreenSize.SCREEN_WIDTH
        var screenSize = CGSize(width: 0, height: 0)
        if screenSize.height >= 1024{
            screenSize =  CGSize(width: screen_width / 6 - 20, height: 100)
        }
        else{
            screenSize = CGSize(width: screen_width / 4 - 10 , height: 100)
        }
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .horizontal
        layout1.itemSize = screenSize
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        categoryColView.setCollectionViewLayout(layout1, animated: true)
        categoryColView.reloadData()
    }
    
    func stopSkeletonView(){
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func reloadData(){
            self.categoryColView.reloadData()
           self.layoutIfNeeded()
    }

    
}

extension HomeCategoryCell: UICollectionViewDelegate, SkeletonCollectionViewDataSource{
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return CategoryCell.identifire
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire, for: indexPath) as! CategoryCell
        let index = categoryArr[indexPath.row]
        let url = index.image_url ?? ""
        if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            let url = URL(string: urlString)
            cell.img.kf.setImage(with: url)
        }
        cell.nameTxt.text = index.name
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = categoryArr[indexPath.row]

        self.delegate?.callSubCategory(id: index.id ?? 0)
    }
    

}
