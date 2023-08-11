//
//  LocationPickVC.swift
//  Marketplix
//
//  Created by Kiran P M on 10/08/23.
//

import UIKit

class LocationPickVC: BaseVC {

    
    lazy var cityModel: CityVM = {
        return CityVM()
    }()
    let getLocation = GetLocation()
    @IBOutlet weak var colView: UICollectionView!
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
            screenSize = CGSize(width: screen_width / 4 - 20, height: 100)
        }
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.itemSize = screenSize
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
        
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        colView.setCollectionViewLayout(layout1, animated: true)
        colView.reloadData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if checkUsersLocationServicesAuthorization(){
            getLocation.run {
                if let location = $0 {
                    self.getLocation.getPlacemark(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude){ placemark in
                        print(placemark?.city ?? "")
                    }
                } else {
                    print("Get Location failed ")
                }
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = ScreenSize.SCREEN_MAX_LENGTH
        let screen_width = ScreenSize.SCREEN_WIDTH
        if screenSize >= 1024{
            return CGSize(width: screen_width / 6 - 20, height: 100)
        }
        else{
            return CGSize(width: screen_width / 4 - 20, height: 100)
        }
    }
    
    

    
    

}
