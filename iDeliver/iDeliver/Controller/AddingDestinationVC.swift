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

class AddingDestinationVC: UIViewController {

    //IBOutles
    
    
    @IBOutlet weak var nameOrBusinessTextField: UITextField!
    @IBOutlet weak var firstLineAddressTextField: UITextField!
    @IBOutlet weak var cityLineAddressTextField: UITextField!
    @IBOutlet weak var postcodeLineAddressTextField: UITextField!
       @IBOutlet weak var countryLineAddressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMapBtn: UIButton!
    
    var delegate: DataSentDelegate?
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: CLLocationDistance = 10000
    var tableView = UITableView()
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var selectedItemPlacemark: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        nameOrBusinessTextField.delegate = self
        firstLineAddressTextField.delegate = self
        countryLineAddressTextField.delegate = self
        cityLineAddressTextField.delegate = self
        postcodeLineAddressTextField.delegate = self
        
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        centerMapOnUserLocation()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Add Destination"
        func textFieldShouldClear(textField: UITextField) -> Bool {
            nameOrBusinessTextField.text = ""
            firstLineAddressTextField.text = ""
            countryLineAddressTextField.text = ""
            cityLineAddressTextField.text = ""
            postcodeLineAddressTextField.text = ""
            return true
        }
       
    }
    func clearTextFields() {
        nameOrBusinessTextField.text = ""
        firstLineAddressTextField.text = ""
        countryLineAddressTextField.text = ""
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
            let addressObj = DeliveryDestinations(NameOrBusiness: nameOrBusinessTextField.text, FirstLineAddress: firstLineAddressTextField.text, SecondLineAddress: countryLineAddressTextField.text, CityLineAddress: cityLineAddressTextField.text, PostCodeLineAddress: postcodeLineAddressTextField.text)
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
        centerMapBtn.fadeTo(alphaValue: 0.0, withDuration: 0.2)
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
    /*
    // Working annotation.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? AddressAnnotation {
            let identifier = "address"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "destinationpin")
            return view
        } else if let annotation = annotation as? MKPointAnnotation {
            let identifier = "destination"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.image = UIImage(named: "DestinationAnnotation")
            return annotationView
        }
        
        return nil
    }
 */
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // 1
        if (view.annotation is MKUserLocation) {
            // Don't proceed with custom callout
            return
        }
        // 2
        let addressAnnotation = view.annotation as? AddressAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.firstAddressPinLbl.text = firstLineAddressTextField.text
        let tableData = MainVC()
        calloutView.numberOfDeliveriesPinLbl.text = String(tableData.addressArr.count)
        
        print(calloutView)
       // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height * 0.5)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    
    // to check from here the custom map anntation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print(mapView.annotations)
        print(annotation.coordinate)
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
            //custom label
            let label = UILabel(frame: CGRect(x: 22, y: 14, width: 30, height: 30))
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.text =  "100" // set text here
            label.minimumScaleFactor = 10
            
            annotationView?.addSubview(label)
            
        }else{
            annotationView?.annotation = annotation
        }
        //mapViewCounter = mapViewCounter + 1
        annotationView?.image = UIImage(named: "pickup_pin")
        annotationView?.tag = 55
        
        //        print(mapView.annotations.count)
        //
        //        for ant in mapView.annotations{
        //            print(ant.title)
        //        }
        //        //print(annotationView?)
        return annotationView
    }
    // ending here custom map annotation
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerMapBtn.fadeTo(alphaValue: 1.0, withDuration: 0.2)
    }
    func performSearch() {
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = firstLineAddressTextField.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if error != nil {
                print(error.debugDescription)
            }  else if response!.mapItems.count == 0 {
                    print("No results!")
                } else {
                    for mapItem in response!.mapItems {
                        self.matchingItems.append(mapItem as MKMapItem)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    func dropPinFor(placemark: MKPlacemark) {
        selectedItemPlacemark = placemark
        
        for annotation in mapView.annotations {
            if annotation.isKind(of: MKPointAnnotation.self) {
               // mapView.removeAnnotation(annotation) // removing the pins from the map
            }
        }

        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        mapView.addAnnotation(annotation)
   }
}


extension AddingDestinationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == firstLineAddressTextField {
            tableView.frame = CGRect(x: 20, y: view.frame.width, width: view.frame.width - 40, height: view.frame.height - 175)
            tableView.layer.cornerRadius = 5.0
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.tag = 18
            tableView.rowHeight = 60
            
            view.addSubview(tableView)
            animateTableView(shouldShow: true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstLineAddressTextField {
            performSearch()
            view.endEditing(true)
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        matchingItems = []
        tableView.reloadData()
       // animateTableView(shouldShow: false)
        centerMapOnUserLocation()
        return true
    }
    func animateTableView(shouldShow: Bool) {
        if shouldShow {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.frame = CGRect(x: 20, y: 215, width: self.view.frame.width - 40, height: self.view.frame.height - 215)
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.frame = CGRect(x: 20, y: self.view.frame.width, width: self.view.frame.width - 40, height: self.view.frame.height - 215)
            }, completion: { (finished) in
                for subview in self.view.subviews {
                    if subview.tag == 18 {
                        subview.removeFromSuperview()
                    }
                }
            })
        }
    }
}

extension AddingDestinationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
        let mapItem = matchingItems[indexPath.row]
        cell.textLabel?.text = mapItem.name
        cell.detailTextLabel?.text = mapItem.placemark.title
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addressCoordinate = locationManager.location?.coordinate
        
        let currentAnnotation = AddressAnnotation(coordinate: addressCoordinate!)
        mapView.addAnnotation(currentAnnotation)
        let fullAddress = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text
        print(fullAddress)
        let fullAddressArr = fullAddress?.components(separatedBy: ",")
        if nameOrBusinessTextField.text != "" {
        } else {
            nameOrBusinessTextField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        }
        firstLineAddressTextField.text = fullAddressArr?[0]
        cityLineAddressTextField.text = fullAddressArr?[1]
        postcodeLineAddressTextField.text = fullAddressArr?[2]
        countryLineAddressTextField.text = fullAddressArr?[3]
        
        
        let selectedMapItem = matchingItems[indexPath.row]
     
        dropPinFor(placemark: selectedMapItem.placemark)
        
        animateTableView(shouldShow: false)
        print("selected!")
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if firstLineAddressTextField.text == "" {
            animateTableView(shouldShow: false)
        }
    }
}

