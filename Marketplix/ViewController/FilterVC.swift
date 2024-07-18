//
//  FilterVC.swift
//  Marketplix
//
//  Created by Kiran P M on 11/08/23.
//

import UIKit

struct FilterStruct{
    var category_id: String = ""
    var location: String = ""
    var lat: String = ""
    var log: String = ""

}

protocol FilterStructDelegate{
    func updateFilterAction(filterStruct: FilterStruct)
}
class FilterVC: UIViewController {
    
    lazy var filterVM: CityVM = {
        return CityVM()
    }()
    var predictionsArr: [Predictions] = []

    var selectedIndex = 0
    var categoryArr = [Category]()
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var filterString = ["Category", "Location"]
    var delegate: FilterStructDelegate?
    var filterVal = [String]()
    var filterData = [Flter]()
    var filterStruct = FilterStruct(category_id: "")
    @IBOutlet weak var tableView: UITableView?{
        didSet{
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.registerCell(FilterMainItems.identifire)
            tableView?.registerCell(CheckBoxCell.identifire)
        }
    }
    
    lazy var cityModel: CityVM = {
        return CityVM()
    }()
    
    lazy var cityDetail: CityVM = {
        return CityVM()
    }()
    
    @IBOutlet weak var tableView2: UITableView?{
        didSet{
            tableView2?.delegate = self
            tableView2?.dataSource = self
            tableView2?.registerCell(CheckBoxCell.identifire)
            tableView2?.register(UINib(nibName: SearchFilterHeader.identifire, bundle: nil), forHeaderFooterViewReuseIdentifier: SearchFilterHeader.identifire)

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
        
        cityModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let cityArr = _self.cityModel.predictions
                self?.predictionsArr = cityArr
          
                self?.tableView2?.reloadData()
                
            }
        }
        
        
        cityDetail.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                    let details = self?.cityDetail.cityDetailResponse
                    

                    self?.filterStruct.location = details?.result?.name ?? ""
                    self?.filterStruct.lat = details?.result?.geometry?.location?.lat?.description ?? ""
                    self?.filterStruct.log = details?.result?.geometry?.location?.lng?.description ?? ""

                
                
            }
        }
        
        
        cityModel.callLocation("", key: Constants.googleApiKey)
        
        filterVM.callFilterValues(filename: "Filter")
        
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        
        let data = categoryArr
        print(data)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func applyBtn(_ sender: Any) {
        self.dismiss(animated: true){
            self.delegate?.updateFilterAction(filterStruct: self.filterStruct)
        }
    }
    
    
}

extension FilterVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView{
            return 1
        }
        else{
            if selectedIndex == 0{
                return categoryArr.count
            }else{
                return 1
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView{
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                return view
        }else{
            if selectedIndex == 0{
                let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
                let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
                label.font = UIFont.systemFont(ofSize: 14)
                label.text = self.categoryArr[section].name ?? ""
                view.addSubview(label)
                view.backgroundColor = UIColor.white // Set your background color
                return view
            }else{
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchFilterHeader.identifire) as! SearchFilterHeader
                view.delegate = self
                return view
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return filterString.count
        }else{
            if selectedIndex == 0{
                return categoryArr[section].sub_category?.count ?? 0
            }else{
                return predictionsArr.count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterMainItems.identifire, for: indexPath) as! FilterMainItems
            cell.filterNameTxt.text = filterString[indexPath.row]
            cell.bgView.backgroundColor = indexPath.row == selectedIndex ? UIColor.primaryColor.withAlphaComponent(0.2) : UIColor.bgColor
            return cell
        }else{
            if selectedIndex == 0{
                let index = self.categoryArr[indexPath.section]
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxCell.identifire, for: indexPath) as! CheckBoxCell
                cell.nameTxt.text = index.sub_category?[indexPath.row].name ?? ""
                if selectedIndexPath == indexPath{
                    cell.img.image = UIImage.checkBox
                }else{
                    cell.img.image = UIImage.un_checkBox
                }
                return cell
            }else{
                let index = self.predictionsArr[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxCell.identifire, for: indexPath) as! CheckBoxCell
                cell.nameTxt.text = index.structured_formatting?.main_text ?? ""
                if selectedIndexPath == indexPath{
                    cell.img.image = UIImage.checkBox
                }else{
                    cell.img.image = UIImage.un_checkBox
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView2{
            if selectedIndex == 0{
                let index = self.categoryArr[indexPath.section]
                let val  = index.sub_category?[indexPath.row]
                self.selectedIndexPath = indexPath
                filterStruct.category_id = val?.id?.description ?? ""
                DispatchQueue.main.async {
                    self.tableView2?.reloadData()
                }
            }else{
                let index = self.predictionsArr[indexPath.row]
                self.cityDetail.callLocationDetail(index.place_id ?? "", key: Constants.googleApiKey)

            }
        }else{
            selectedIndex = indexPath.row
            self.tableView?.reloadData()
            self.tableView2?.reloadData()
        }
    }
    
}

extension FilterVC: SearchFilterHeaderDelegate{
    func updateTxt(val: String) {
        self.predictionsArr.removeAll()
        self.tableView2?.reloadData()
        self.cityModel.callLocation(val, key: Constants.googleApiKey)
    }
    
    
}
