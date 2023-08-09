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

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 7
        

    }

}
