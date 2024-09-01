//
//  FilterDatePickerCell.swift
//  Marketplix
//
//  Created by Kiran PM on 27/07/24.
//

import UIKit
protocol FilterDatePickerDelegate{
    func choosenDate(date: String, actualDate: Date)
}

class FilterDatePickerCell: UITableViewCell {
    var delegate : FilterDatePickerDelegate?
    @IBOutlet weak var datepicker: UIDatePicker!
    static let identifire = "FilterDatePickerCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        datepicker.maximumDate = Date()
        datepicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)

        datepicker.datePickerMode = .date
        datepicker.preferredDatePickerStyle = .wheels
    }

    @objc func handleDatePicker(_ datePicker: UIDatePicker) {
        let date = datePicker.date.getFormattedDate(format: "yyyy-MM-dd")
        delegate?.choosenDate(date: date, actualDate: datePicker.date)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
