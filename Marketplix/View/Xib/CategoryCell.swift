//
//  CategoryCell.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var nameTxt: MPUILabel!
    static let identifire: String = "CategoryCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

}
