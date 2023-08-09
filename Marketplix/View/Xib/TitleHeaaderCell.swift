//
//  TitleHeaaderCell.swift
//  Marketplix
//
//  Created by Kiran PM on 18/05/23.
//

import UIKit

protocol TitleHeaaderCellDelegate{
    func viewAllAction(header: String)
}
class TitleHeaaderCell: UITableViewCell {

    static let identifire = "TitleHeaaderCell"
    var delegate: TitleHeaaderCellDelegate?
    @IBOutlet weak var titleTxt: MPUILabel!
    var header: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func View_btn(_ sender: Any) {
        delegate?.viewAllAction(header: self.header)
    }
}
