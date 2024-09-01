//
//  NotificationCell.swift
//  Marketplix
//
//  Created by Kiran PM on 24/07/24.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var titleLbl: MPUILabel!
    @IBOutlet weak var subTitleLbl: MPUILabel!
    static var identifire: String = "NotificationCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
