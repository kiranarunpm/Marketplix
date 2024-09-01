//
//  HomeNewItems.swift
//  Marketplix
//
//  Created by Kiran P M on 09/08/23.
//

import UIKit
import DropDown

protocol HomeNewItemsDelegate{
    func favActionHander(indexPath: IndexPath, type: String, id: String)
    func editAction(dataList: DataList?)
    func deleteAction(dataList: DataList?)
    func closeAction(dataList: DataList?)

}
extension HomeNewItemsDelegate{
    func closeAction(dataList: DataList?){
    }
    func deleteAction(dataList: DataList?){
    }
}
class HomeNewItems: UICollectionViewCell {
    @IBOutlet weak var categoryLbl: MPUILabel!
    @IBOutlet weak var distanceLbl: MPUILabel!
    var dataList: DataList?
    @IBOutlet weak var distanceStack: UIStackView!
    @IBOutlet weak var createdAtLbl: MPUILabel!
    @IBOutlet weak var bgView: R_UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var soldOutImg: UIImageView!

    @IBOutlet weak var waitingView: R_UIView!
    var indexPath = IndexPath(row: 0, section: 0)
    var delegete: HomeNewItemsDelegate?
    @IBOutlet weak var price: MPUILabel!
    static var identifire = "HomeNewItems"
    var type: String = ""
    var id = ""
    let dropDown = DropDown()
    @IBOutlet weak var dropView: DropDown!
    @IBOutlet weak var menuOptionsBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 5
        dropDown.width = 150
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
    
    @IBAction func menuOptionsBtn(_ sender: Any) {
        dropDown.anchorView = dropView // UIView or UIBarButtonItem
        self.dropDown.dataSource = ["Edit Ad", "Sold Out" ,"Delete Ad"]
        self.dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDown.hide()
            if item == "Edit Ad"{
                self.delegete?.editAction(dataList: self.dataList)
            }else if item == "Sold Out" {
                self.delegete?.closeAction(dataList: self.dataList)


            }else{
                self.delegete?.deleteAction(dataList: self.dataList)

            }

        }
    }
    
}
