//
//  RadioButtonCell.swift
//  Marketplix
//
//  Created by Kiran on 04/10/23.
//

import UIKit
protocol RadioButtonDelegate{
    func radioHandler(value: String, index: IndexPath)
}
class RadioButtonCell: UITableViewCell {
    static let identifire: String = "RadioButtonCell"
    var index : IndexPath  = IndexPath(row: 0, section: 0)

    @IBOutlet weak var rentImg: UIImageView!
    @IBOutlet weak var sellImg: UIImageView!
    var delegate: RadioButtonDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func sellBtn(_ sender: Any) {
        self.delegate?.radioHandler(value: "1", index: index)
    }
    
    @IBAction func rentBtn(_ sender: Any) {
        self.delegate?.radioHandler(value: "2", index: index)
    }
    
}
