//
//  loaderCell.swift
//  Marketplix
//
//  Created by Kiran P M on 10/08/23.
//

import UIKit

class loaderCell: UITableViewCell {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    var loader: Bool?{
        didSet{
            activity.startAnimating()

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
