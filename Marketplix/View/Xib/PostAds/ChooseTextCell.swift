//
//  ChooseTextCell.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit

class ChooseTextCell: UITableViewCell {
    static let identifire: String = "ChooseTextCell"
    @IBOutlet weak var valueTxt: UITextField!
    @IBOutlet weak var nameTxt: MPUILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
