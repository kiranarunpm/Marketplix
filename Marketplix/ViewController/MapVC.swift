//
//  MapVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

struct Stadium {
    var name: String
    var lattitude: CLLocationDegrees
    var longtitude: CLLocationDegrees
}

import UIKit
import MapKit
class MapVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    private let reuseIdentifier = "MyIdentifier"
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    var stadiums = [Stadium(name: "kochi", lattitude: 9.9312, longtitude: 76.2673),
                    Stadium(name: "Stamford Bridge", lattitude: 51.4816, longtitude: -0.191034),
                    Stadium(name: "White Hart Lane", lattitude: 51.6033, longtitude: -0.065684),
                    Stadium(name: "Olympic Stadium", lattitude: 51.5383, longtitude: -0.016587),
                    Stadium(name: "Old Trafford", lattitude: 53.4631, longtitude: -2.29139),
                    Stadium(name: "Anfield", lattitude: 53.4308, longtitude: -2.96096)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        checkLocationServices()
        mapView.delegate = self
        
        fetchStadiumsOnMap(stadiums)
        
        
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied: // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
            
        default: break
            
        }
    }
    
    func fetchStadiumsOnMap(_ stadiums: [Stadium]) {
        for stadium in stadiums {
            let annotations = MKPointAnnotation()
            annotations.title = stadium.name
            annotations.coordinate = CLLocationCoordinate2D(latitude:
                                                                stadium.lattitude, longitude: stadium.longtitude)
            mapView.addAnnotation(annotations)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05 )
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Javed Multani"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
}

