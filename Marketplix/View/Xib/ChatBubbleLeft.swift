//
//  ChatBubbleLeft.swift
//  Marketplix
//
//  Created by Kiran PM on 05/07/23.
//

import UIKit

class ChatBubbleLeft: UITableViewCell {

    @IBOutlet weak var dateTxt: MPUILabel!
    @IBOutlet weak var txxt: MPUILabel!
    static var identifire : String = "ChatBubbleLeft"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
