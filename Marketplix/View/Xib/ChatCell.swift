//
//  ChatCell.swift
//  Marketplix
//
//  Created by Kiran PM on 05/07/23.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var msgTxt: MPUILabel!
    @IBOutlet weak var nameTxt: MPUILabel!
    static var identifre : String = "ChatCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
