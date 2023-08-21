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
    var selectedIndex: Int = 0
    var filterVal = [String]()
    var filterData = [Flter]()
    @IBOutlet weak var tableView: UITableView?{
        didSet{
            tableView?.delegate = self
            tableView?.dataSource = self
            //            tableView?.separatorStyle = .none
            tableView?.registerCell(FilterMainItems.identifire)
            tableView?.registerCell(CheckBoxCell.identifire)
        }
    }
    
    @IBOutlet weak var tableView2: UITableView?{
        didSet{
            tableView2?.delegate = self
            tableView2?.dataSource = self
            tableView2?.registerCell(CheckBoxCell.identifire)
        }
    }
    // MARK: InitViewModel
    func initViewModel() {
        
        filterVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            _self.filterData = _self.filterVM.filterArr
            for i in 0...(_self.filterData.count - 1){
                let data = [String]()
                _self.filterData[i].selected = data
            }
            
            DispatchQueue.main.async {
                
                let cityArr = _self.filterVM.filterArr
                print("cityArr: : \(cityArr)")
                self?.tableView?.reloadData()
                self?.tableView2?.reloadData()
                
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
    
    @IBAction func applyBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}

extension FilterVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return self.filterData.count
        }else{
            return self.filterData[selectedIndex].value?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterMainItems.identifire, for: indexPath) as! FilterMainItems
            cell.filterNameTxt.text = self.filterData[indexPath.row].key ?? ""
            
            cell.bgView.backgroundColor = indexPath.row == selectedIndex ? UIColor.primaryColor.withAlphaComponent(0.2) : UIColor.bgColor
            return cell
        }else{
            let index = self.filterData[selectedIndex]
            if index.type == "Checkbox"{
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxCell.identifire, for: indexPath) as! CheckBoxCell
                cell.nameTxt.text = index.value?[indexPath.row].name ?? ""
                if index.selected?.contains(index.value?[indexPath.row].name ?? "") == true{
                    cell.img.image = UIImage.checkBox
                }
                else {
                    cell.img.image = UIImage.un_checkBox
                }
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView2{
            let index = self.filterData[selectedIndex].value?[indexPath.row]
            let value = index?.name ?? ""
            if self.filterData[selectedIndex].selected?.contains(value) == true{
                let indexVal = self.filterData[selectedIndex].selected?.firstIndex(of: value)
                self.filterData[selectedIndex].selected?.remove(at: indexVal ?? 0)
            }
            else{
                self.filterData[selectedIndex
                ].selected?.append(value)
            }
            
            DispatchQueue.main.async {
                self.tableView2?.reloadData()
            }
        }else{
            selectedIndex = indexPath.row
            self.tableView?.reloadData()
            self.tableView2?.reloadData()

        }
    }
    
}
