//
//  NewListingBaseTabCell.swift
//  Marketplix
//
//  Created by Kiran on 04/05/2024.
//

import UIKit

protocol NewListingBaseTabCellDelegate {
    func toDetail(_ id: Int, distance: String)
    func favActionHander(indexPath: IndexPath, type: String, id: String)

}


class NewListingBaseTabCell: UITableViewCell {
    static var identifire: String = "NewListingBaseTabCell"
    @IBOutlet weak var colView: UICollectionView!
    var new_listing: [NewListing]?
    var delegate: NewListingBaseTabCellDelegate?
    var type = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colView.register(UINib(nibName: HomeNewItems.identifire, bundle: nil), forCellWithReuseIdentifier: HomeNewItems.identifire)
        colView.dataSource = self
        colView.delegate = self
    }
    func reloadData(){
        colView.reloadData()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension NewListingBaseTabCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return new_listing?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        cell.delegete = self
        cell.categoryLbl.text = "\(index?.category?.name ?? "")"
        let price : Double = Double(index?.price ?? "") ?? 0
        cell.price.text = Constants.currencySymbol + "\(price.roundedDecimal(to: 0))"
        cell.distanceLbl.text = index?.addresses?.distance ?? ""
        cell.type = "New Listing"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = ScreenSize.SCREEN_MAX_LENGTH
        let screen_width = ScreenSize.SCREEN_WIDTH
        return CGSize(width: screen_width - 60, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let index = new_listing?[indexPath.row]
        self.delegate?.toDetail(index?.id ?? 0, distance: index?.addresses?.distance ?? "")
    }
}

extension NewListingBaseTabCell: HomeNewItemsDelegate{
    func favActionHander(indexPath: IndexPath, type: String, id: String) {
        self.delegate?.favActionHander(indexPath: indexPath, type: type, id: id)
    }
    
    
}
