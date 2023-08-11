//
//  FilterVC.swift
//  Marketplix
//
//  Created by Kiran P M on 11/08/23.
//

import UIKit

class FilterVC: UIViewController {
    
    lazy var filterVM: CityVM = {
        return CityVM()
    }()
    @IBOutlet weak var tableView: UITableView?{
        didSet{
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.separatorStyle = .none
            tableView?.registerCell(FilterMainItems.identifire)
        }
    }
    // MARK: InitViewModel
    func initViewModel() {
        
        filterVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let cityArr = _self.filterVM.filterArr
                print("cityArr: : \(cityArr)")
                self?.tableView?.reloadData()
                
            }
        }
        filterVM.callFilterValues(filename: "Filter")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
 

}

extension FilterVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterVM.filterArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterMainItems.identifire, for: indexPath) as! FilterMainItems
        cell.filterNameTxt.text = filterVM.filterArr[indexPath.row].key ?? ""
        
        return cell
    }
    
    
}
