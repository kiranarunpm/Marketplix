//
//  DescriptionTextCell.swift
//  Marketplix
//
//  Created by Kiran on 03/05/2024.
//

import UIKit
protocol DescriptionTextDelegate {
    func setvalue(value: String, index: IndexPath)
}
class DescriptionTextCell: UITableViewCell, UITextViewDelegate {
    static let identifire = "DescriptionTextCell"
    @IBOutlet weak var valueTxt: UITextView!
    @IBOutlet weak var nameTxt: MPUILabel!
    var index : IndexPath  = IndexPath(row: 0, section: 0)
    var delegate: DescriptionTextDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTxt.delegate = self
        valueTxt.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        delegate?.setvalue(value: valueTxt.text ?? "", index: index)
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.setvalue(value: valueTxt.text ?? "", index: index)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.setvalue(value: valueTxt.text ?? "", index: index)
        return true
    }
    
}
