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
import CoreData

class AddingDestinationVC: UIViewController, Alertable {

    //IBOutlets
    
    
    @IBOutlet weak var nameOrBusinessTextField: UITextField!
    @IBOutlet weak var firstLineAddressTextField: UITextField!
    @IBOutlet weak var cityLineAddressTextField: UITextField!
    @IBOutlet weak var postcodeLineAddressTextField: UITextField!
    @IBOutlet weak var countryLineAddressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMapBtn: UIButton!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: CLLocationDistance = 10000
    var tableView = UITableView()
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var route: MKRoute!
    var distance: CLLocationDistance = CLLocationDistance()
    var selectedItemPlacemark: MKPlacemark? = nil
    
    var destlat: Double = Double()
    var destlong: Double = Double()
    
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
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else  { return }
        let dropOffLocations = DropOffLocation(context: managedContext)
        
        dropOffLocations.nameOrBusiness = nameOrBusinessTextField.text!
        dropOffLocations.street = firstLineAddressTextField.text!
        dropOffLocations.city = cityLineAddressTextField.text!
        dropOffLocations.postcode = postcodeLineAddressTextField.text!
        dropOffLocations.country = countryLineAddressTextField.text!
        dropOffLocations.distance = distance
        dropOffLocations.latitude = destlat
        dropOffLocations.longitude = destlong
        dropOffLocations.isInTranzit = false
        dropOffLocations.dateCreated = NSDate() as Date
        
        do {
               try managedContext.save()
            print("Succesfully saved data!")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }

    @IBAction func addBtnWasPressed(_ sender: Any) {
        if firstLineAddressTextField.text != "" && cityLineAddressTextField.text != "" && postcodeLineAddressTextField.text != "" {
            self.save(completion: { (complete) in
                if complete {
                            clearTextFields()
                }
            })
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
    //creating the line between 2 points working need to move this to different VC
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineRenderer = MKPolylineRenderer(overlay: self.route.polyline)
        lineRenderer.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        lineRenderer.lineWidth = 3
        
        shouldPresentLoadingView(false)
        
        zoom(toFitAnnotationsFromMapView: self.mapView)
        
        return lineRenderer
    }

    
    ////////
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation
//        {
//            return nil
//        }
//        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "CustomMapPin")
//        if annotationView == nil{
//            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "CustomMapPin")
//            annotationView?.canShowCallout = false
//        }else{
//            annotationView?.annotation = annotation
//        }
//        annotationView?.image = UIImage(named: "CustomMapPin")
//        return annotationView
//    }
    
     //Working annotation.
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotation = annotation as? AddressAnnotation {
//           // let identifier = "address"
//            var view: MKAnnotationView
//            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomMapPin")
//            return view
//        } else if let annotation = annotation as? MKPointAnnotation {
//            let identifier = "destination"
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            if annotationView == nil {
//                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView?.canShowCallout = false
//            } else {
//                annotationView?.annotation = annotation
//            }
//            annotationView?.image = UIImage(named: "CustomMapPin")
//            annotationView?.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0) //--->anchor the pin image to the exact coordinate and not move the pin when zooming
//            return annotationView
//        }
//
//        return nil
//    }
 
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // 1
        if (view.annotation is MKUserLocation) {
            // Don't proceed with custom callout
            return
        }
        // 2
        let addressAnnotation = view.annotation as? AddressAnnotation
        let customView = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)![0] as! CustomCalloutView
        customView.nameOrBusinessLbl.text = addressAnnotation?.nameOrBusiness
        customView.secondLineAddressLbl.text = addressAnnotation?.cityName
        customView.postcodeLineAddressLbl.text = addressAnnotation?.postcode
        customView.numberOfDeliveriesLbl.text = String(Helper.getLocationCount() + 1)
        print(customView)
       // 3
        customView.center = CGPoint(x: view.bounds.size.width / 2, y: -customView.bounds.size.height * 0.5)

        view.addSubview(customView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "MyCustomAnnotation"
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            if case let annotationView as CustomAnnotationView = annotationView {
                annotationView.isEnabled = true
                annotationView.canShowCallout = false
                annotationView.numberOfDropsLbl = UILabel(frame: CGRect(x: 60.0, y: 20.0, width: 22.0, height: 18.0))
                if let label = annotationView.numberOfDropsLbl {
                    label.font = UIFont(name: "AvenirNext-DemiBold", size: 25.0)
                    label.textAlignment = .center
                    label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    label.adjustsFontSizeToFitWidth = true
                    annotationView.addSubview(label)
                }
            }
        }

        if case let annotationView as CustomAnnotationView = annotationView {
            annotationView.annotation = annotation
            annotationView.image = #imageLiteral(resourceName: "CustomMapPin")
            annotationView.layer.anchorPoint = CGPoint(x: 0, y: 1.0) //--->anchor the pin image to the exact coordinate and not move the pin when zooming
            if let label = annotationView.numberOfDropsLbl {
                label.text = String(Helper.getLocationCount() + 1)
            }
        }
        return annotationView
    }
    
    
    // to check from here the custom map anntation
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        print(mapView.annotations)
//        print(annotation.coordinate)
//
//        if (annotation is MKUserLocation) {
//            return nil
//        }
    
//        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
//            annotationView?.canShowCallout = false
//            //custom label
//            let label = UILabel(frame: CGRect(x: 22, y: 14, width: 30, height: 30))
//            label.textColor = .white
//            label.font = UIFont.boldSystemFont(ofSize: 15)
//            label.text =  "100" // set text here
//            label.minimumScaleFactor = 10
//
//            annotationView?.addSubview(label)
//
//        }else{
//            annotationView?.annotation = annotation
//        }
//        //mapViewCounter = mapViewCounter + 1
//        annotationView?.image = UIImage(named: "dropPin")
//        annotationView?.tag = 55
    
        //        print(mapView.annotations.count)
        //
        //        for ant in mapView.annotations{
        //            print(ant.title)
        //        }
        //        //print(annotationView?)
//        return annotationView
//    }
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
                self.showAlert("An error occured, please try again")
               self.shouldPresentLoadingView(false)
            }  else if response!.mapItems.count == 0 {
                self.showAlert("No results! Please search again for a different location.")
                } else {
                    for mapItem in response!.mapItems {
                        self.matchingItems.append(mapItem as MKMapItem)
                        self.tableView.reloadData()
                        self.shouldPresentLoadingView(false)
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
        destlat = placemark.coordinate.latitude
        destlong = placemark.coordinate.longitude
        //print("This is the pins destinations coord \(destlat, destlong)")
   }
 
    func searchMapKitForResultsWithPolyline(forMapItem mapItem: MKMapItem) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapItem
        request.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                self.showAlert("An error occurred, please try again.")
               // print(error.debugDescription)
                return
            }
            self.route = response.routes[0]
            
            self.mapView.add(self.route.polyline)
            
            let delegate = AppDelegate.getAppDelegate()
            delegate.window?.rootViewController?.shouldPresentLoadingView(false)
            
            self.distance = self.route.distance * 0.00062137
            //print(self.distance)
        }
    }
    func zoom(toFitAnnotationsFromMapView mapView: MKMapView) {
        if mapView.annotations.count == 0 {
            return
        }
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        for annotation in mapView.annotations {
            topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
            topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude )
            bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
            bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
        }
        var region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.5, topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5), span: MKCoordinateSpan(latitudeDelta: fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 2.0, longitudeDelta: fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 2.0))
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
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
            shouldPresentLoadingView(true)
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
        
        shouldPresentLoadingView(true)
        
        let addressCoordinate = locationManager.location?.coordinate
        
        print("This is the coordinates of the current user location: \(String(describing: addressCoordinate))")

        
        let currentAnnotation = AddressAnnotation(coordinate: addressCoordinate!)
        //mapView.addAnnotation(currentAnnotation) // add pin to current location
        
        let fullAddress = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text
        
        print(fullAddress as Any)
        
        let fullAddressArr = fullAddress?.components(separatedBy: ",")
        if nameOrBusinessTextField.text == "" {
            nameOrBusinessTextField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        }
        //print(fullAddressArr?.count)
             //check to see if there is a better way to check if the string is empty
        if fullAddressArr?.count == 1 {
            //print(fullAddressArr)
                firstLineAddressTextField.text = fullAddressArr?[0]
        } else if fullAddressArr?.count == 2 {
                firstLineAddressTextField.text = fullAddressArr?[0]
                cityLineAddressTextField.text = fullAddressArr?[1]
        } else if fullAddressArr?.count == 3 {
                firstLineAddressTextField.text = fullAddressArr?[0]
                cityLineAddressTextField.text = fullAddressArr?[1]
                postcodeLineAddressTextField.text = fullAddressArr?[2]
        } else if fullAddressArr?.count == 4 {
                firstLineAddressTextField.text = fullAddressArr?[0]
                cityLineAddressTextField.text = fullAddressArr?[1]
                postcodeLineAddressTextField.text = fullAddressArr?[2]
                countryLineAddressTextField.text = fullAddressArr?[3]
        }
    
        
        let selectedMapItem = matchingItems[indexPath.row]
     
        dropPinFor(placemark: selectedMapItem.placemark)
        
        print("This is the pin destination coordinates \(selectedMapItem.placemark.coordinate)")
        searchMapKitForResultsWithPolyline(forMapItem: selectedMapItem)
        
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

