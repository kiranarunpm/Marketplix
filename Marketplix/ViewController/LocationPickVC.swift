//
//  LocationPickVC.swift
//  Marketplix
//
//  Created by Kiran P M on 10/08/23.
//

import UIKit
import CoreLocation

protocol LocationPickDelegate{
    func getLocation(_ location: String, lat: String, lng: String)
}

class LocationPickVC: BaseVC {

    lazy var cityModel: CityVM = {
        return CityVM()
    }()
    var isPresant: Bool = false

    lazy var cityDetail: CityVM = {
        return CityVM()
    }()
    let getLocation = GetLocation()
    var delegate: LocationPickDelegate?
    var predictionsArr: [Predictions] = []
    @IBOutlet weak var searchTxt: UITextField!
    var location = ""
    @IBOutlet weak var tabView: UITableView!{
        didSet{
            tabView?.delegate = self
            tabView?.dataSource = self
            tabView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTxt.delegate = self
        initViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    // MARK: InitViewModel
    func initViewModel() {
        
        cityModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let cityArr = _self.cityModel.predictions
                self?.predictionsArr = cityArr
          
                self?.tabView.reloadData()
                
            }
        }
        
        
        cityDetail.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                self?.dismiss(animated: true){
                    let details = self?.cityDetail.cityDetailResponse
                    self?.delegate?.getLocation(details?.result?.name ?? "", lat: details?.result?.geometry?.location?.lat?.description ?? "", lng: details?.result?.geometry?.location?.lng?.description ?? "")
                }
                
            }
        }
        
        
        cityModel.callLocation("", key: Constants.googleApiKey)
    }
    
    
    @IBAction func currentLocBtn(_ sender: Any) {
        setupLocation()
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }


}


extension LocationPickVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityModel.predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text =  cityModel.predictions[indexPath.row].structured_formatting?.main_text ?? ""
        cell.textLabel?.font = .MPfont(.regular, size: 14)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = cityModel.predictions[indexPath.row]
        let val = index.structured_formatting?.main_text ?? ""
        location = index.structured_formatting?.main_text ?? ""
        cityDetail.callLocationDetail(index.place_id ?? "", key: Constants.googleApiKey)
        

    }
    
}

extension LocationPickVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && range.length == 1 && string == "" {
            self.self.predictionsArr.removeAll()
            self.tabView.reloadData()
        }else {
            if range.length == 1 {
                let txt = textField.text!.dropLast()
                self.cityModel.callLocation(String(txt), key: Constants.googleApiKey)
            }else {
                if let text = textField.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    self.cityModel.callLocation(updatedText, key: Constants.googleApiKey)
                }
            }
        }
        return true
    }
}

extension LocationPickVC: CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                let locality = placemark.locality ?? ""
                let replaceSpace = locality.replacingOccurrences(of: " ", with: "_")
   
                
                self.locationManager.stopUpdatingLocation()
                self.dismiss(animated: true){
                    self.delegate?.getLocation(locality, lat: userLocation.coordinate.latitude.description, lng: userLocation.coordinate.longitude.description)
                }
               
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

