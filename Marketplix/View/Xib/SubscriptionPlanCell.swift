//
//  SubscriptionPlanCell.swift
//  Marketplix
//
//  Created by Kiran on 08/10/23.
//

import UIKit
struct SubscriptionValues{
    var key : String
    var value: String
}

class SubscriptionPlanCell: UICollectionViewCell {
    static var identifire: String = "SubscriptionPlanCell"

    @IBOutlet weak var price: MPUILabel!
    @IBOutlet weak var nameTxt: MPUILabel!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCell(DetailSpecCell.identifire)
            
        }
    }
    var data = [SubscriptionValues]()
    
    var indexValue: Subscription_plans?{
        didSet{
            nameTxt.text = indexValue?.name ?? ""
            price.text = "\(Constants.currencySymbol)\(indexValue?.price ?? "")"
            var content = [SubscriptionValues]()
            let limit = indexValue?.ad_limit ?? 0
            let validity  = indexValue?.validity ?? 0
            let validFrom = indexValue?.available_from ?? ""
            let available_to = indexValue?.available_to ?? ""

            content.append(SubscriptionValues(key: "Limit", value: "\(limit)"))
            content.append(SubscriptionValues(key: "Validity", value: "\(validity)"))
            content.append(SubscriptionValues(key: "Valid From", value: "\(validFrom)"))
            content.append(SubscriptionValues(key: "Valid To", value: "\(available_to)"))
            
            data = content
            
            tableView.reloadData()

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension SubscriptionPlanCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailSpecCell.identifire, for: indexPath) as! 
        DetailSpecCell
        let index = data[indexPath.row]
        cell.spec_txt.text = "\(index.key) \n \(index.value)"
        cell.spec_txt.textAlignment = .center
        cell.contentView.backgroundColor = UIColor.white
        
        return cell
    }
}
