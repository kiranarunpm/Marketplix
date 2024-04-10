//
//  GalleryPickerCell.swift
//  Prima luxury
//
//  Created by Kiran on 26/09/22.
//

import UIKit

protocol GalleryPickerDelegate{
    func delete(row: Int)
}
class GalleryPickerCell: UICollectionViewCell {
    @IBOutlet weak var imageVeiw: UIImageView!
    var delegate : GalleryPickerDelegate?
    var row = -1
    @IBOutlet weak var close_btn: UIButton!
    static var identifire: String = "GalleryPickerCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func delete_btn(_ sender: Any) {
        self.delegate?.delete(row: self.row)
    }
}
