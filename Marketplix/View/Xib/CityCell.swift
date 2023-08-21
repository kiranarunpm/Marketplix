//
//  CityCell.swift
//  Marketplix
//
//  Created by Kiran P M on 11/08/23.
//

import UIKit

class CityCell: UICollectionViewCell {

    @IBOutlet weak var cityNameTxt: MPUILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 8
        // Initialization code
    }

}
