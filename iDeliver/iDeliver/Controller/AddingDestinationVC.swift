//
//  AddingDestination.swift
//  iDeliver
//
//  Created by Marius Dragan on 12/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol DataSentDelegate {
    //Replace parameter with DeliveryDestinations
    func userDidEnterData(addressObj: DeliveryDestinations)
}

class AddingDestinationVC: UIViewController, UITextFieldDelegate {

    //IBOutles
    
    @IBOutlet weak var firstLineAddressTextField: UITextField!
    @IBOutlet weak var secondLineAddressTextField: UITextField!
    @IBOutlet weak var cityLineAddressTextField: UITextField!
    @IBOutlet weak var postcodeLineAddressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: DataSentDelegate?
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        firstLineAddressTextField.delegate = self
        secondLineAddressTextField.delegate = self
        cityLineAddressTextField.delegate = self
        postcodeLineAddressTextField.delegate = self
        
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        centerMapOnUserLocation()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Add Destination"
        func textFieldShouldClear(textField: UITextField) -> Bool {
            firstLineAddressTextField.text = ""
            secondLineAddressTextField.text = ""
            cityLineAddressTextField.text = ""
            postcodeLineAddressTextField.text = ""
            return true
        }
       
    }
    func clearTextFields() {
        firstLineAddressTextField.text = ""
        secondLineAddressTextField.text = ""
        cityLineAddressTextField.text = ""
        postcodeLineAddressTextField.text = ""
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
    @IBAction func addBtnWasPressed(_ sender: Any) {
         if delegate != nil {
        if firstLineAddressTextField.text != "" && cityLineAddressTextField.text != "" && postcodeLineAddressTextField.text != "" {
            
                //Create Model object DeliveryDestinations
                let addressObj = DeliveryDestinations(FirstLineAddress: firstLineAddressTextField.text, SecondLineAddress: secondLineAddressTextField.text, CityLineAddress: cityLineAddressTextField.text, PostCodeLineAddress: postcodeLineAddressTextField.text)
                //add that object to previous view with delegate
                delegate?.userDidEnterData(addressObj: addressObj)
                //Dismising VC
                //navigationController?.popViewController(animated: true)
          clearTextFields()
            }
        }
        
    }
    
    @IBAction func centreMapBtnWasPressed(_ sender: Any) {
        checkLocationAuthStatus()
        centerMapOnUserLocation()
        }
    }

extension AddingDestinationVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard (locationManager.location?.coordinate) != nil else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension AddingDestinationVC: CLLocationManagerDelegate {
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




