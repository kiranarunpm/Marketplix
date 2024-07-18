//
//  TextCell.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit
protocol TextCellDelegate {
    func setvalue(value: String, index: IndexPath)
}
class TextCell: UITableViewCell, UITextFieldDelegate {
    static let identifire: String = "TextCell"
    var delegate: TextCellDelegate?
    @IBOutlet weak var valueTxt: UITextField!
    @IBOutlet weak var nameTxt: MPUILabel!
    var index : IndexPath  = IndexPath(row: 0, section: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        valueTxt.delegate = self
        valueTxt.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))

    }
    @objc func doneButtonClicked(_ sender: Any) {
        delegate?.setvalue(value: valueTxt.text ?? "", index: index)
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.setvalue(value: valueTxt.text ?? "", index: index)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.setvalue(value: valueTxt.text ?? "", index: index)
        return false

    }
}
