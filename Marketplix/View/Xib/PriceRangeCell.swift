//
//  PriceRangeCell.swift
//  Marketplix
//
//  Created by Kiran PM on 29/08/24.
//

import UIKit
protocol PriceRangeDelegate{
    func applyMinPriceRange(val : String)
    func applyMaxPriceRange(val : String)

}
class PriceRangeCell: UITableViewCell {
    static let identifire = "PriceRangeCell"
    var delegate: PriceRangeDelegate?
    @IBOutlet weak var minPriceTxt: UITextField!
    var activeTextField: Int = 1
    @IBOutlet weak var maxPriceTxt: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.maxPriceTxt.delegate = self
        self.minPriceTxt.delegate = self
        minPriceTxt.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        maxPriceTxt.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))

    }

    @objc func doneButtonClicked(_ sender: Any) {
        if activeTextField == 1{
            delegate?.applyMinPriceRange(val: self.minPriceTxt.text ?? "")

        }else{
            delegate?.applyMaxPriceRange(val: self.maxPriceTxt.text ?? "")

        }
    }
   
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
extension PriceRangeCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.minPriceTxt{
           activeTextField = 1
            delegate?.applyMinPriceRange(val: self.minPriceTxt.text ?? "")
        }else{
            activeTextField = 2
            delegate?.applyMaxPriceRange(val: self.maxPriceTxt.text ?? "")
        }

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.minPriceTxt{
           activeTextField = 1
           delegate?.applyMinPriceRange(val: self.minPriceTxt.text ?? "")
        }else{
            activeTextField = 2
            delegate?.applyMaxPriceRange(val: self.maxPriceTxt.text ?? "")
        }
        return false

    }
}
