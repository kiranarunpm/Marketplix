//
//  SelectVC.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit
protocol SelectVCDelegate{
    func selectedIndex(category: Category, index: IndexPath, nameString: String)
        
}

class SelectVC: UIViewController {

    @IBOutlet weak var nametxt: MPUILabel!
    var categoryArr = [Category]()
    var index : IndexPath  = IndexPath(row: 0, section: 0)
    var delegate: SelectVCDelegate?
    var nameString = ""
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCell(SelectCell.identifire)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nametxt.text = nameString
    }

    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension SelectVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectCell.identifire, for: indexPath) as! SelectCell
        cell.nameTxt.text = categoryArr[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = categoryArr[indexPath.row]
        self.dismiss(animated: true) {
            self.delegate?.selectedIndex(category: index, index: self.index, nameString: self.nameString)
        }
    }
    
}
