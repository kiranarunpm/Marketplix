//
//  HomeNewItems.swift
//  Marketplix
//
//  Created by Kiran P M on 09/08/23.
//

import UIKit

class HomeNewItems: UICollectionViewCell {

    @IBOutlet weak var bgView: R_UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var price: MPUILabel!
    static var identifire = "HomeNewItems"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
    }
    
    func loadImage(url: URL){
        self.img.kf.setImage(with: url)
    }

}
