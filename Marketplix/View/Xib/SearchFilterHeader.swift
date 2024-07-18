//
//  SearchFilterHeader.swift
//  Marketplix
//
//  Created by Kiran PM on 28/06/24.
//

import UIKit

protocol SearchFilterHeaderDelegate {
    func updateTxt(val: String)
}
class SearchFilterHeader: UITableViewHeaderFooterView {
    static let identifire = "SearchFilterHeader"
    var delegate: SearchFilterHeaderDelegate?
    
    @IBOutlet weak var searchTxt: UITextField!
    override func draw(_ rect: CGRect) {
        self.searchTxt.delegate = self

    }


}

extension SearchFilterHeader: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && range.length == 1 && string == "" {
            
        }else {
            if range.length == 1 {
                let txt = textField.text!.dropLast()
                self.delegate?.updateTxt(val: String(txt))
            }else {
                if let text = textField.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    self.delegate?.updateTxt(val: String(updatedText))
                }
            }
        }
        return true
    }
    
}
