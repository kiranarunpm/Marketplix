//
//  ItemViewTabCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit
protocol ItemViewTabDelegate {
    func toDetail(_ id: Int)
}

class ItemViewTabCell: UITableViewCell {
    static let identifire = "ItemViewTabCell"
    var type: String = ""
    @IBOutlet weak var colView: UICollectionView!
    var new_listing: [NewListing]?
    var featuredListingArr = [DataList]()
    var recommendationArr = [DataList]()
    var recentlyViewArr = [DataList]()
    var delegate: ItemViewTabDelegate?

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

    func reloadData(){
        colView.reloadData()
    }
    
}


extension ItemViewTabCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            cell.descriptions.text = "Created: \(index?.created_at?.convertDateFormat(dateFormat: "dd MMM yyyy") ?? "")"
            if let url = URL(string:  index?.classified_images?.first?.image_url ?? ""){
                cell.loadImage(url: url)

            }
            return cell
        }else if type == "Featured Listing"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
            let index = featuredListingArr[indexPath.row]
            cell.homeIndexList = index
            return cell
            
        }else if type == "Recommendations"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
            let index = recommendationArr[indexPath.row]
            cell.homeIndexList = index
            return cell
            
        }else if type == "Recently Viewed"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
            let index = recentlyViewArr[indexPath.row]
            cell.homeIndexList = index
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == "New Listing"{
            let index = new_listing?[indexPath.row]
            self.delegate?.toDetail(index?.id ?? 0)
        }else if type == "Featured Listing"{
            let index = featuredListingArr[indexPath.row]
            self.delegate?.toDetail(index.classifieds?.id ?? 0)
        }else if type == "Recommendations"{
            let index = recommendationArr[indexPath.row]
            self.delegate?.toDetail(index.classifieds?.id ?? 0)
        }else if type == "Recently Viewed"{
            let index = recentlyViewArr[indexPath.row]
            self.delegate?.toDetail(index.classifieds?.id ?? 0)
        }
        
    }
    
    
    
    
}
