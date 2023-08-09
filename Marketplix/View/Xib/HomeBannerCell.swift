//
//  HomeBannerCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit
import ImageSlideshow
class HomeBannerCell: UITableViewCell {
    @IBOutlet weak var imageSideShow: ImageSlideshow!
    static let identifire =  "HomeBannerCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        imageSideShow.setImageInputs([
                    ImageSource(image: UIImage(named: "banner 1")!), ImageSource(image: UIImage(named: "banner 2")!), ImageSource(image: UIImage(named: "banner 3")!)])
        imageSideShow.circular = true
        imageSideShow.slideshowInterval = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
