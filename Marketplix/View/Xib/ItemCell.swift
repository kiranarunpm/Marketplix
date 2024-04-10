//
//  ItemCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    static let identifire = "ItemCell"

    @IBOutlet weak var priceTxt: MPUILabel!
    @IBOutlet weak var mileTxt: MPUILabel!
    @IBOutlet weak var subTxt: MPUILabel!
    @IBOutlet weak var nameTxt: MPUILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var favImg: UIButton!
    var indexVal : DataList?{
        didSet{
            img.downloaded(from: indexVal?.classified_images?.first?.image_url ?? "", contentMode: .scaleToFill)
            nameTxt.text = indexVal?.title ?? ""
            subTxt.text = indexVal?.description ?? ""
            priceTxt.text = Constants.currencySymbol + (indexVal?.price ?? "")
            
            let isFav = indexVal?.is_fav ?? 0
            if isFav == 1{
                self.favImg.setImage(UIImage(named: "favorite-filled"), for: .normal)
            }else{
                self.favImg.setImage(UIImage(named: "favorite"), for: .normal)
            }
            
        }
    }
    
    var homeIndexList : DataList?{
        didSet{
            let image = homeIndexList?.classifieds?.classified_images?.first?.image_url ?? ""
            let convertUrl  = URL(string: image)
            self.img.kf.setImage(with: convertUrl)
            nameTxt.text = homeIndexList?.classifieds?.title ?? ""
            subTxt.text = "Created: \(homeIndexList?.created_at?.convertDateFormat(dateFormat: "dd MMM yyyy") ?? "")"
            priceTxt.text = Constants.currencySymbol + (homeIndexList?.classifieds?.price ?? "")

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 7
        

    }

}
