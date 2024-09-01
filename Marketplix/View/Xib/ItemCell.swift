//
//  ItemCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit
import Kingfisher
protocol ItemDelegate{
    func favActionHander(indexPath: IndexPath, type: String, id: String)
}

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    static let identifire = "ItemCell"
    var delegete: ItemDelegate?
    @IBOutlet weak var priceTxt: MPUILabel!
    @IBOutlet weak var subTxt: MPUILabel!
    @IBOutlet weak var nameTxt: MPUILabel!
    @IBOutlet weak var categoryLbl: MPUILabel!
    @IBOutlet weak var distanceLbl: MPUILabel!
    @IBOutlet weak var categortTxtLbl: MPUILabel!
    @IBOutlet weak var distanceTxtLbl: MPUILabel!

    @IBOutlet weak var img: UIImageView!
    var indexPath = IndexPath(row: 0, section: 0)
    var type: String = ""
    var id = ""
    @IBOutlet weak var createdAtLbl: MPUILabel!
    @IBOutlet weak var favImg: UIButton!
    var indexVal : DataList?{
        didSet{
            let url = indexVal?.classified_images?.first?.image_url ?? ""

            if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                let url = URL(string: urlString)
                img.kf.setImage(with: url,options: [
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage
                ])
            }
            nameTxt.text = indexVal?.title ?? ""
            subTxt.text = indexVal?.addresses?.sector ?? ""
            let price : Double = Double(indexVal?.price ?? "") ?? 0
            priceTxt.text = Constants.currencySymbol + "\(price.roundedDecimal(to: 0))"

            createdAtLbl.text = "Posted on: \(indexVal?.time_diff ?? "1 day ago")"
            self.categoryLbl.text = "\(indexVal?.category?.name ?? "")"

            let isFav = indexVal?.is_fav ?? 0
            if isFav == 1{
                self.favImg.setImage(UIImage(named: "favorite-filled"), for: .normal)
            }else{
                self.favImg.setImage(UIImage(named: "favorite"), for: .normal)
            }
            favImg.isHidden = false
            self.distanceLbl.text = indexVal?.addresses?.distance ?? ""
            self.categortTxtLbl.text = "Category : "
            self.distanceTxtLbl.text = "Distance : "
        }
    }
    
    var homeIndexList : DataList?{
        didSet{
            let image = homeIndexList?.classifieds?.classified_images?.first?.image_url ?? ""
            let convertUrl  = URL(string: image)
            self.img.kf.setImage(with: convertUrl)
            nameTxt.text = homeIndexList?.classifieds?.title ?? ""
            subTxt.text = homeIndexList?.classifieds?.addresses?.sector ?? ""
            createdAtLbl.text = "Posted on: \(homeIndexList?.classifieds?.time_diff ?? "1 day ago")"
            self.categoryLbl.text = "\(homeIndexList?.classifieds?.category?.name ?? "")"
            favImg.isHidden = false
            let price : Double = Double(homeIndexList?.classifieds?.price ?? "") ?? 0
            priceTxt.text = Constants.currencySymbol + "\(price.roundedDecimal(to: 0))"
            self.distanceLbl.text = homeIndexList?.classifieds?.addresses?.distance ?? ""
            self.categortTxtLbl.text = "Category : "
            self.distanceTxtLbl.text = "Distance : "
            
            let isFav = homeIndexList?.is_fav ?? 0
            if isFav == 1{
                self.favImg.setImage(UIImage(named: "favorite-filled"), for: .normal)
            }else{
                self.favImg.setImage(UIImage(named: "favorite"), for: .normal)
            }
            favImg.isHidden = false
        }
    }
    
    var recentlyViewed : DataList?{
        didSet{
            let image = recentlyViewed?.classifieds?.classified_images?.first?.image_url ?? ""
            let convertUrl  = URL(string: image)
            self.img.kf.setImage(with: convertUrl)
            nameTxt.text = recentlyViewed?.classifieds?.title ?? ""
            subTxt.text = recentlyViewed?.classifieds?.addresses?.sector ?? ""
            createdAtLbl.text = "Posted on: \(recentlyViewed?.time_diff ?? "1 day ago")"
            self.categoryLbl.text = "\(recentlyViewed?.classifieds?.category?.name ?? "")"
            favImg.isHidden = false
            let price : Double = Double(recentlyViewed?.classifieds?.price ?? "") ?? 0
            priceTxt.text = Constants.currencySymbol + "\(price.roundedDecimal(to: 0))"
            self.distanceLbl.text = recentlyViewed?.classifieds?.addresses?.distance ?? ""
            self.categortTxtLbl.text = "Category : "
            self.distanceTxtLbl.text = "Distance : "
            
            let isFav = recentlyViewed?.is_fav ?? 0
            if isFav == 1{
                self.favImg.setImage(UIImage(named: "favorite-filled"), for: .normal)
            }else{
                self.favImg.setImage(UIImage(named: "favorite"), for: .normal)
            }
            favImg.isHidden = false
        }
    }
    
    var recommentedList : DataList?{
        didSet{
            let image = recommentedList?.classified_images?.first?.image_url ?? ""
            let convertUrl  = URL(string: image)
            self.img.kf.setImage(with: convertUrl)
            nameTxt.text = recommentedList?.title ?? ""
            subTxt.text = recommentedList?.addresses?.sector ?? ""
            createdAtLbl.text = "Posted on: \(recommentedList?.time_diff ?? "1 day ago")"
      
            favImg.isHidden = false
            self.categoryLbl.text = "\(recommentedList?.category?.name ?? "")"

            let price : Double = Double(recommentedList?.price ?? "") ?? 0
            priceTxt.text = Constants.currencySymbol + "\(price.roundedDecimal(to: 0))"
            self.distanceLbl.text = recommentedList?.addresses?.distance ?? ""
            self.categortTxtLbl.text = "Category : "
            self.distanceTxtLbl.text = "Distance : "
            
            let isFav = recommentedList?.is_fav ?? 0
            if isFav == 1{
                self.favImg.setImage(UIImage(named: "favorite-filled"), for: .normal)
            }else{
                self.favImg.setImage(UIImage(named: "favorite"), for: .normal)
            }
            favImg.isHidden = false
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        
        
        

    }
    
    @IBAction func favBtn(_ sender: Any) {
        delegete?.favActionHander(indexPath: self.indexPath, type: self.type, id: self.id)
    }
    
}

extension Double {
    /// Convert `Double` to `Decimal`, rounding it to `scale` decimal places.
    ///
    /// - Parameters:
    ///   - scale: How many decimal places to round to. Defaults to `0`.
    ///   - mode:  The preferred rounding mode. Defaults to `.plain`.
    /// - Returns: The rounded `Decimal` value.

    func roundedDecimal(to scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var decimalValue = Decimal(self)
        var result = Decimal()
        NSDecimalRound(&result, &decimalValue, scale, mode)
        return result
    }
    
    func convertCourrencyFomat() -> String{
        let rounded = self.roundedDecimal(to: 0)
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: rounded as NSNumber) {
            return formattedTipAmount
        }else{
            return "0.0"
        }
    }
}
