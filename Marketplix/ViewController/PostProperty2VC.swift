//
//  PostProperty2VC.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import UIKit
import CoreLocation
import MapKit

class PostProperty2VC: BaseVC {

    var postRealEstateArr  = [PostRealEstateModel]()

    @IBOutlet weak var maps: R_UIView!
    lazy var cityModel: CityVM = {
        return CityVM()
    }()
    
    var lat: String = ""
    var long: String = ""
    lazy var cityDetail: CityVM = {
        return CityVM()
    }()
    @IBOutlet weak var searchLocation: MPUILabel!
    @IBOutlet weak var mapView: MKMapView!
    var predictionsArr: [Predictions] = []
    var isOnEdit = false
    var editData : DataList?

    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTxt.delegate = self
        initViewModel()
        
        
        
    }
    
    
    // MARK: InitViewModel
    func initViewModel() {
        
        cityModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let cityArr = _self.cityModel.predictions
                self?.predictionsArr = cityArr
          
                self?.tableView.reloadData()
                
            }
        }
        
        
        cityDetail.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                self?.dismiss(animated: true){
                    let details = self?.cityDetail.cityDetailResponse
                    self?.tableView.isHidden = true
//                    self?.delegate?.getLocation(self?.searchTxt.text ?? "", lat: details?.result?.geometry?.location?.lat?.description ?? "", lng: details?.result?.geometry?.location?.lng?.description ?? "")
                    self?.searchLocation.text = details?.result?.formatted_address ?? ""
                    let center = CLLocationCoordinate2D(latitude: Double(details?.result?.geometry?.location?.lat?.description ?? "") ?? 0, longitude: Double(details?.result?.geometry?.location?.lng?.description ?? "") ?? 0)
                         let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                         self?.mapView.setRegion(region, animated: true)
                    self?.lat = details?.result?.geometry?.location?.lat?.description ?? ""
                    self?.long = details?.result?.geometry?.location?.lng?.description ?? ""

                    let london = MKPointAnnotation()
                    london.title = self?.searchLocation.text ?? ""
                    london.coordinate = CLLocationCoordinate2D(latitude: Double(details?.result?.geometry?.location?.lat?.description ?? "") ?? 0, longitude: Double(details?.result?.geometry?.location?.lng?.description ?? "") ?? 0)
                    self?.mapView.delegate = self
                    self?.mapView.addAnnotation(london)
                    _self.maps.isHidden = false
                    _self.searchLocation.isHidden = false

                }
                
            }
        }
        
        
        cityModel.callLocation("", key: Constants.googleApiKey)
        
        if isOnEdit{
            var j = 0
            for item in self.postRealEstateArr{
                if item.name == "Location Details"{
                    var i = 0
                    item.results?.forEach({ item in
                        if item.name == "Sector"{
                            self.postRealEstateArr[j].results?[i].value = editData?.addresses?.sector ?? ""
                            self.searchLocation.text = editData?.addresses?.sector ?? ""
                        }
                        if item.name == "Lat"{
                            self.postRealEstateArr[j].results?[i].value = editData?.addresses?.lat ?? ""
                        }
                        if item.name == "Long"{
                            self.postRealEstateArr[j].results?[i].value = editData?.addresses?.lng ?? ""
                        }
                        i += 1
                    })
                    
                    let center = CLLocationCoordinate2D(latitude: Double(editData?.addresses?.lat ?? "") ?? 0, longitude: Double(editData?.addresses?.lng ?? "") ?? 0)
                         let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                         self.mapView.setRegion(region, animated: true)
                    self.lat = editData?.addresses?.lat ?? ""
                    self.long = editData?.addresses?.lng ?? ""

                    let london = MKPointAnnotation()
                    london.title = editData?.addresses?.sector ?? ""
                    london.coordinate = CLLocationCoordinate2D(latitude: Double(editData?.addresses?.lat ?? "") ?? 0, longitude: Double(editData?.addresses?.lng ?? "") ?? 0)
                    self.mapView.delegate = self
                    self.mapView.addAnnotation(london)
                }
                j += 1
            }
            


        }
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        if searchLocation.text == ""{
            self.showToastLogIn(message: "Please choose address")
            return
        }
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
        
            
            if item.name == "Sector"{
                self.postRealEstateArr[ind].results?[i].value = self.searchLocation.text ?? ""
            }
            
            if item.name == "Lat"{
                self.postRealEstateArr[ind].results?[i].value = self.lat
            }
            if item.name == "Long"{
                self.postRealEstateArr[ind].results?[i].value = self.long
            }

            i += 1
        })
        
        let storyboard = PostImageVC.instantiate(fromAppStoryboard: .Main)
        storyboard.postRealEstateArr = self.postRealEstateArr
        storyboard.isOnEdit = self.isOnEdit
        storyboard.editData = self.editData
        self.navigationController?.pushViewController(storyboard, animated: true)

    }
    
    
}

extension PostProperty2VC: UITableViewDataSource, UITableViewDelegate{
    
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
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let index = cityModel.predictions[indexPath.row]
        let val = index.structured_formatting?.main_text ?? ""
        cityDetail.callLocationDetail(index.place_id ?? "", key: Constants.googleApiKey)
        

    }
    
}



extension PostProperty2VC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.maps.isHidden = true
        self.searchLocation.isHidden = true
        tableView.isHidden = false
        if range.location == 0 && range.length == 1 && string == "" {
            self.self.predictionsArr.removeAll()
            self.tableView.reloadData()
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
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.tableView.isHidden = false
        return true
    }
}

extension PostProperty2VC: MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
