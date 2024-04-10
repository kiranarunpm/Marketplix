//
//  SelectCell.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit

class SelectCell: UITableViewCell {
    static let identifire: String = "SelectCell"

    @IBOutlet weak var nameTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
