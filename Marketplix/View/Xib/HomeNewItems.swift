//
//  HomeNewItems.swift
//  Marketplix
//
//  Created by Kiran P M on 09/08/23.
//

import UIKit

protocol HomeNewItemsDelegate{
    func favActionHander(indexPath: IndexPath, type: String, id: String)
}
class HomeNewItems: UICollectionViewCell {
    @IBOutlet weak var categoryLbl: MPUILabel!
    @IBOutlet weak var distanceLbl: MPUILabel!

    @IBOutlet weak var distanceStack: UIStackView!
    @IBOutlet weak var createdAtLbl: MPUILabel!
    @IBOutlet weak var bgView: R_UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var img: UIImageView!
    var indexPath = IndexPath(row: 0, section: 0)
    var delegete: HomeNewItemsDelegate?
    @IBOutlet weak var price: MPUILabel!
    static var identifire = "HomeNewItems"
    var type: String = ""
    var id = ""
    
    @IBOutlet weak var favBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 5
    }
    
    func loadImage(url: URL){
        
        self.img.kf.setImage(with: url, options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage
        ])
    }
    

    @IBAction func favBtn(_ sender: Any) {
        delegete?.favActionHander(indexPath: indexPath, type: self.type, id: self.id)
    }
    
}
