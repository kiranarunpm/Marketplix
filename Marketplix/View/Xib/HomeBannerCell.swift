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


        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.red
        pageIndicator.pageIndicatorTintColor = UIColor.gray
        imageSideShow.pageIndicator = pageIndicator
//        imageSideShow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .right(padding: 5), vertical: .customBottom(padding: 5))


    }
    
    func loadBannerImage(image: [String]){
        
        var imaged = [KingfisherSource]()
        image.forEach { item in
            let urlString = item.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            imaged.append(KingfisherSource(urlString: urlString ?? "")!)
        }
        imageSideShow.circular = true
        imageSideShow.slideshowInterval = 8
        imageSideShow.contentScaleMode = .scaleAspectFill
        imageSideShow.setImageInputs(imaged)


        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
