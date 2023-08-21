//
//  ItemViewTabCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit

class ItemViewTabCell: UITableViewCell {
    static let identifire = "ItemViewTabCell"
    var type: String = ""
    @IBOutlet weak var colView: UICollectionView!
    var new_listing: [NewListing]?
    override func awakeFromNib() {
        super.awakeFromNib()
        colView.register(UINib(nibName: ItemCell.identifire, bundle: nil), forCellWithReuseIdentifier: ItemCell.identifire)
        self.colView.register(UINib(nibName: HomeNewItems.identifire, bundle: nil), forCellWithReuseIdentifier: HomeNewItems.identifire)
        
        colView.dataSource = self
        colView.delegate = self
        
    }

    
    func getScreenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }

    
}


extension ItemViewTabCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return new_listing?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type == "New Listing"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNewItems.identifire, for: indexPath) as! HomeNewItems
            let index = new_listing?[indexPath.row]
            if let url = URL(string:  index?.classified_images?.first?.image_url ?? ""){
                cell.img.downloaded(from: url)

            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
            return cell
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = ScreenSize.SCREEN_MAX_LENGTH
        let screen_width = ScreenSize.SCREEN_WIDTH
        
        if type == "New Listing"{
            return CGSize(width: screen_width - 60, height: 130)
        }else{
           

            if screenSize >= 1024{
                return CGSize(width: screen_width / 4 - 20, height: 260)
            }
            else{

                return CGSize(width: screen_width / 2 - 20, height: 260)
            }
        }
    }
    
    
    
    
    
}
