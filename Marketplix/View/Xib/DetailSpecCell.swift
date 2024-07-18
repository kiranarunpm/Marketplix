//
//  DetailSpecCell.swift
//  Marketplix
//
//  Created by Kiran on 08/10/23.
//

import UIKit

class DetailSpecCell: UITableViewCell {

    @IBOutlet weak var spec_txt: MPUILabel!
    @IBOutlet weak var valueTxt: MPUILabel!

    static let identifire = "DetailSpecCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
