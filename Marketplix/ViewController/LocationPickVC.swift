//
//  LocationPickVC.swift
//  Marketplix
//
//  Created by Kiran P M on 10/08/23.
//

import UIKit

protocol LocationPickDelegate{
    func getLocation(_ location: String)
}

class LocationPickVC: BaseVC {

    lazy var cityModel: CityVM = {
        return CityVM()
    }()
    let getLocation = GetLocation()
    @IBOutlet weak var colView: UICollectionView!
    var delegate: LocationPickDelegate?
    @IBOutlet weak var tabView: UITableView?{
        didSet{
            tabView?.delegate = self
            tabView?.dataSource = self
            tabView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        colView.register(UINib(nibName: "CityCell", bundle: nil), forCellWithReuseIdentifier: "CityCell")
        colView.delegate = self
        colView.dataSource = self
        
        let screen_width = ScreenSize.SCREEN_WIDTH
        var screenSize = CGSize(width: 0, height: 0)
        if screenSize.height >= 1024{
            screenSize =  CGSize(width: screen_width / 6 - 20, height: 100)
        }
        else{
            screenSize = CGSize(width: screen_width / 4 - 8, height: 100)
        }
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.itemSize = screenSize
        //        layout1.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        
        //        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        colView.setCollectionViewLayout(layout1, animated: true)
        colView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
//        if checkUsersLocationServicesAuthorization(){
//            getLocation.run {
//                if let location = $0 {
//                    self.getLocation.getPlacemark(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude){ placemark in
//                        print(placemark?.city ?? "")
//                    }
//                } else {
//                    print("Get Location failed ")
//                }
//            }
//        }
    }
    
    
    // MARK: InitViewModel
    func initViewModel() {
        
        cityModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let cityArr = _self.cityModel.cityArr
                print("cityArr: : \(cityArr)")
                self?.colView.reloadData()
                
            }
        }
        cityModel.callCityNames(filename: "Cities")
    }
    
    
    @IBAction func currentLocBtn(_ sender: Any) {
        if checkUsersLocationServicesAuthorization(){

        }
    }
    
    
}
extension LocationPickVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityModel.cityArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CityCell
        let index = cityModel.cityArr[indexPath.row]
        cell.cityNameTxt.text = index.title
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let val = cityModel.cityArr[indexPath.row]
        dismiss(animated: true){
            self.delegate?.getLocation(val.title)
        }

    }
    
}

extension LocationPickVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "Kochi"
        cell.contentView.backgroundColor = UIColor.bgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let val = cell.textLabel?.text ?? ""
        dismiss(animated: true){
            self.delegate?.getLocation(val)

        }

    }
    
}
