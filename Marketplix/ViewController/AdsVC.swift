//
//  AdsVC.swift
//  Marketplix
//
//  Created by Kiran PM on 07/06/23.
//

import UIKit
import ImageSlideshow
 
class AdsVC: UIViewController {

    @IBOutlet weak var slideShow: ImageSlideshow!
    var flashArr = [Flash]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
  
    }
    
    @IBAction func close_btn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setUI(){
        var source = [KingfisherSource]()
        flashArr.forEach { item in
            source.append(KingfisherSource(url: NSURL(string: item.image_url ?? "")! as URL))
        }
        
        slideShow.setImageInputs(source)
        slideShow.circular = true
        slideShow.slideshowInterval = 8
    }
    

}
