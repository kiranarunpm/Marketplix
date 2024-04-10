//
//  PostMainCatColCell.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import UIKit

class PostMainCatColCell: UICollectionViewCell {
    static var identifire: String = "PostMainCatColCell"

    @IBOutlet weak var tick: UIImageView!
    @IBOutlet weak var lbl: MPUILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadImage(url: String){
        let convertUrl  = URL(string: url)
        self.img.kf.setImage(with: convertUrl)
    }
}



