//
//  PostProperty2VC.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import UIKit
import CoreLocation
import LocationPicker
class PostProperty2VC: UIViewController, CLLocationManagerDelegate {

    var postRealEstateArr  = [PostRealEstateModel]()

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let locationManager = CLLocationManager()

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCell(ChooseTextCell.identifire)
            tableView.registerCell(TextCell.identifire)
            tableView.registerCell(RadioButtonCell.identifire)
            tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                tableViewHeight.constant = newsize.height
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // Handle the error (e.g., location services are disabled)
        }

        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let storyboard = PostImageVC.instantiate(fromAppStoryboard: .Main)
        storyboard.postRealEstateArr = self.postRealEstateArr
        self.navigationController?.pushViewController(storyboard, animated: true)

    }
    
    @IBAction func pickLocation(_ sender: Any) {
        let locationPicker = LocationPickerViewController()

        // you can optionally set initial location
        let location = CLLocation(latitude: 35, longitude: 35)
//        let initialLocation = Location(name: "My home", location: location, placemark: CLPlacemark)
//        locationPicker.location = initialLocation

        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true

        // default: navigation bar's `barTintColor` or `UIColor.white`
        locationPicker.currentLocationButtonBackground = .blue

        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true

        locationPicker.mapType = .standard // default: .Hybrid

        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false

        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"

        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"

        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600

        locationPicker.completion = { location in
        
            var ind = 0
            var j = 0
            self.postRealEstateArr.forEach { item in
                if item.name == "Location Details"{
                    ind = j
                }
                j += 1
            }
            
            var i = 0
            self.postRealEstateArr[ind].results?.forEach({ item in
                if item.name == "Building Name"{
                    self.postRealEstateArr[ind].results?[i].value = location?.placemark.name ?? ""
                }
                
                if item.name == "Street Name"{
                    self.postRealEstateArr[ind].results?[i].value = location?.placemark.streetName ?? ""
                }
                
                if item.name == "Sector"{
                    self.postRealEstateArr[ind].results?[i].value = location?.placemark.locality ?? ""
                }
                
                if item.name == "Sub Sector"{
                    self.postRealEstateArr[ind].results?[i].value = location?.placemark.subLocality ?? ""
                }
                
                if item.name == "Pincode"{
                    self.postRealEstateArr[ind].results?[i].value = location?.placemark.postalCode?.description ?? ""
                }
                
                i += 1
            })

            self.tableView.reloadData()

            
        }
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(locationPicker, animated: true)
    }
    
}

extension PostProperty2VC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return true
            }else{
                return false
            }
        }
        return filter.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return true
            }else{
                return false
            }
        }
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
            let label = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        label.font = UIFont.MPfont(.semibold, size: 17)
            label.text = filter[section].name ?? ""
        label.textAlignment = .center
            view.addSubview(label)
        return view
     }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return true
            }else{
                return false
            }
        }
        return filter.first?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return true
            }else{
                return false
            }
        }
        let index = filter.first?.results?[indexPath.row]
        if index?.type == "text"{
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifire, for: indexPath) as! TextCell
            cell.nameTxt.text = index?.name
            cell.valueTxt.text = index?.value
            cell.valueTxt.placeholder = index?.name
            cell.delegate = self
            cell.valueTxt.keyboardType = index?.type ?? "" == "text" ? .default : .numberPad
            cell.index = indexPath
            return cell
        }
        else if index?.type == "select"{
            let cell = tableView.dequeueReusableCell(withIdentifier: ChooseTextCell.identifire, for: indexPath) as! ChooseTextCell
            cell.nameTxt.text = index?.name
            cell.valueTxt.text = index?.value
            cell.valueTxt.placeholder = index?.name
            return cell
        }
        
        else if index?.type == "radio"{
            let cell = tableView.dequeueReusableCell(withIdentifier: RadioButtonCell.identifire, for: indexPath) as! RadioButtonCell
            if index?.value == "1"{
                cell.sellImg.image = UIImage(named: "radio-active")
                cell.rentImg.image = UIImage(named: "radio-inactive")

            }else{
                cell.sellImg.image = UIImage(named: "radio-inactive")
                cell.rentImg.image = UIImage(named: "radio-active")
            }
            cell.index = indexPath
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return true
            }else{
                return false
            }
        }
        
    }
    
    
}
extension PostProperty2VC: TextCellDelegate, SelectVCDelegate, RadioButtonDelegate{
    func radioHandler(value: String, index: IndexPath) {
        print("value", value)
        var i = 0
        
        postRealEstateArr[index.section].results?.forEach { item in
            if i == index.row{
                postRealEstateArr[index.section].results?[i].value = value
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            i += 1
        }
    }
    
    func setvalue(value: String, index: IndexPath) {
        print("value", value)
        var ind = 0
        var j = 0
        postRealEstateArr.forEach { item in
            if item.name == "Location Details"{
                ind = j
            }
            j += 1
        }
        
        var i = 0
        postRealEstateArr[ind].results?.forEach { item in
            if i == index.row{
                postRealEstateArr[ind].results?[index.row].value = value
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            
            i += 1
        }
    }
    
    

    
    func selectedIndex(category: Category, index: IndexPath, nameString: String) {
        print("value", category.name ?? "")
        
        postRealEstateArr[index.section].results?.forEach( { item in
                postRealEstateArr[index.section].results?[index.row].value = category.name ?? ""
            postRealEstateArr[index.section].results?[index.row].id = category.id?.description ?? ""


                
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
      

    }
                
  
    
}
