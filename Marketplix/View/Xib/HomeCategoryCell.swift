//
//  HomeCategoryCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit
import Kingfisher
struct CategoryModel{
    let name: String
    let image: String
}

protocol HomeCategoryCellDelegate {

}
class HomeCategoryCell: UITableViewCell {
    static let identifire = "HomeCategoryCell"
    var categoryArr =  [Category]()
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

    func reloadData(){
        DispatchQueue.main.async {
            self.categoryColView.reloadData()
        }
    }

    
}

extension HomeCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire, for: indexPath) as! CategoryCell
        let index = categoryArr[indexPath.row]
        cell.nameTxt.text = index.name
        let image = index.image_url
        cell.img.image = UIImage(url: image)
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
