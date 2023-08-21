//
//  CheckBoxCell.swift
//  Marketplix
//
//  Created by Kiran P M on 14/08/23.
//

import UIKit

class CheckBoxCell: UITableViewCell {
    @IBOutlet weak var nameTxt: MPUILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var img: UIImageView!

    static let identifire = "CheckBoxCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
