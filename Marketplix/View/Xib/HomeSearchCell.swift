//
//  HomeSearchCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit

class HomeSearchCell: UITableViewCell {
    let names = ["Searh Land", "Search Property", "Search Car", "Search Laptops"]

    @IBOutlet weak var searchTxt: UITextField!
    static let identifire = "HomeSearchCell"
    override func awakeFromNib() {
        super.awakeFromNib()
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(pickRandomWord), userInfo: nil, repeats: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        @objc func pickRandomWord() {
            let randomName = names.randomElement()!
            UIView.animate(withDuration: 0.5, delay: 0,  options: .curveEaseIn,  animations: {
                self.searchTxt.placeholder = randomName
            })
        }
}
