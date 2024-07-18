//
//  ChatBubbleLeft.swift
//  Marketplix
//
//  Created by Kiran PM on 05/07/23.
//

import UIKit

class ChatBubbleRight: UITableViewCell {

    @IBOutlet weak var dateTxt: MPUILabel!
    @IBOutlet weak var txxt: MPUILabel!
    @IBOutlet weak var nameTxt: MPUILabel!

    static var identifire : String = "ChatBubbleRight"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
