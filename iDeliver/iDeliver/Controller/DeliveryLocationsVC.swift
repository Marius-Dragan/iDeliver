//
//  DeliveryLocationsVC.swift
//  iDeliver
//
//  Created by Marius Dragan on 17/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DeliveryLocationsVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMapBtn: UIButton!
    
    var addressArr = [DeliveryDestinations]()
    var locations = [Location]()
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 10000
    let authorizationStatus = CLLocationManager.authorizationStatus()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthStatus()
        
        mapView.delegate = self
        locationManager.delegate = self
        centerMapOnUserLocation()
        
        //print(addressArr)
        
        
        navigationItem.title = "Delivery Location"
        // Do any additional setup after loading the view.
        
         //get coordinates from object
        for object in addressArr {
            locations = [Location(title: object.FirstLineAddress!, latitude: object.Lat!, longitude: object.Long!)]
            print(locations)
//            let title = object.FirstLineAddress
//            let lat = object.Lat
//            let long = object.Long
            
//            print(lat as Any)
//            print(long as Any)
        
         // get coordinates from object and index for this
//        for (i, object) in addressArr.enumerated() {
//            let lat = object.Lat
//            let long = object.Long
//            print ("Destination at index \(i) has coordinate: (\(String(describing: lat)), \(String(describing: long)))")
//        }
        }
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotation)
        }

    }
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        checkLocationAuthStatus()
        centerMapOnUserLocation()
        centerMapBtn.fadeTo(alphaValue: 0.0, withDuration: 0.2)
    }
    func checkLocationAuthStatus() {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
extension DeliveryLocationsVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard (locationManager.location?.coordinate) != nil else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
extension DeliveryLocationsVC: CLLocationManagerDelegate {
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
        centerMapOnUserLocation()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }

}

