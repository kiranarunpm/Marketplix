//
//  ItemViewTabCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit
import SkeletonView
protocol ItemViewTabDelegate {
    func toDetail(_ id: Int, distance: String)
    func favActionHander(indexPath: IndexPath, type: String, id: String)

}

class ItemViewTabCell: UITableViewCell, ItemDelegate {
    static let identifire = "ItemViewTabCell"
    var type: String = ""
    @IBOutlet weak var colView: UICollectionView!
    var new_listing: [NewListing]?
    var featuredListingArr = [DataList]()
    var recommendationArr = [DataList]()
    var recentlyViewArr = [DataList]()
    var delegate: ItemViewTabDelegate?
var selectedIndex = IndexPath(row: 0, section: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        colView.register(UINib(nibName: ItemCell.identifire, bundle: nil), forCellWithReuseIdentifier: ItemCell.identifire)
        self.colView.register(UINib(nibName: HomeNewItems.identifire, bundle: nil), forCellWithReuseIdentifier: HomeNewItems.identifire)
        
        colView.dataSource = self
        colView.delegate = self
        
//        colView.isSkeletonable = true
//        colView.showAnimatedGradientSkeleton(animation: nil, transition: .crossDissolve(0.25))
        
        
    }

    
    func getScreenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }

    func reloadData(){
        colView.reloadData()
    }
    
}


extension ItemViewTabCell: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return ItemCell.identifire
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == "New Listing"{
            return new_listing?.count ?? 0

        }else if type == "Featured Listing"{
            return featuredListingArr.count

        }else if type == "Recommendations"{
            return recommendationArr.count

        }
        else if type == "Recently Viewed"{
            return recentlyViewArr.count

        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type == "New Listing"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNewItems.identifire, for: indexPath) as! HomeNewItems
            let index = new_listing?[indexPath.row]
            cell.name.text = index?.title ?? ""
            cell.id = index?.id.description ?? ""
            cell.descriptions.text = index?.addresses?.sector ?? ""
           
            let dateFormat = "".dateFormat(index?.created_at ?? "")
            cell.createdAtLbl.text = "Posted on: \(dateFormat)"
            if let url = URL(string:  index?.classified_images?.first?.image_url ?? ""){
                cell.loadImage(url: url)

            }
            let isFav = index?.is_fav ?? 0
            if isFav == 1{
                cell.favBtn.setImage(UIImage(named: "favorite-filled"), for: .normal)
            }else{
                cell.favBtn.setImage(UIImage(named: "favorite"), for: .normal)
            }
            cell.type = type
            cell.delegete = self
            cell.categoryLbl.text = "\(index?.category?.name ?? "")"
            let price : Double = Double(index?.price ?? "") ?? 0
            cell.price.text = Constants.currencySymbol + "\(price.roundedDecimal(to: 0))"
            cell.indexPath = indexPath
            return cell
        }else if type == "Featured Listing"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
            let index = featuredListingArr[indexPath.row]
            cell.type = "Featured Listing"
            cell.homeIndexList = index
            cell.delegete = self
            cell.indexPath = indexPath
            cell.id = index.id?.description ?? "0"
            return cell
            
        }else if type == "Recommendations"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
            let index = recommendationArr[indexPath.row]
            cell.type = "Recommendations"
            cell.recommentedList = index
            cell.delegete = self
            cell.indexPath = indexPath
            cell.id = index.id?.description ?? "0"

            return cell
            
        }else if type == "Recently Viewed"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
            let index = recentlyViewArr[indexPath.row]
            cell.type = "Recently Viewed"
            cell.homeIndexList = index
            cell.delegete = self
            cell.indexPath = indexPath
            cell.id = index.id?.description ?? "0"

            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
            cell.delegete = self
            cell.indexPath = indexPath

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
                return CGSize(width: screen_width / 4 - 20, height: 280)
            }
            else{

                return CGSize(width: screen_width / 2 - 20, height: 280)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == "New Listing"{
            let index = new_listing?[indexPath.row]
            self.delegate?.toDetail(index?.id ?? 0, distance: index?.addresses?.distance ?? "")
        }else if type == "Featured Listing"{
            let index = featuredListingArr[indexPath.row]
            self.delegate?.toDetail(index.classifieds?.id ?? 0, distance: index.classifieds?.addresses?.distance ?? "")
        }else if type == "Recommendations"{
            let index = recommendationArr[indexPath.row]
            self.delegate?.toDetail(index.id ?? 0, distance: index.addresses?.distance ?? "")
        }else if type == "Recently Viewed"{
            let index = recentlyViewArr[indexPath.row]
            self.delegate?.toDetail(index.classifieds?.id ?? 0, distance: index.classifieds?.addresses?.distance ?? "")
        }
        
    }
    
    
    
    
}

extension ItemViewTabCell: HomeNewItemsDelegate{
    func favActionHander(indexPath: IndexPath, type: String, id: String) {
        self.delegate?.favActionHander(indexPath: indexPath, type: type, id: id)
    }
    
    
}
