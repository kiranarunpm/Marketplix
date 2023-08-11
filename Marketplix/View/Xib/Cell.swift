//
//  Cell.swift
//  Marketplix
//
//  Created by Kiran P M on 10/08/23.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var sub_txt: UILabel!
    @IBOutlet weak var title_txt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
