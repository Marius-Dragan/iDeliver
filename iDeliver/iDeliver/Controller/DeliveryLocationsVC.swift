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
import CoreData

class DeliveryLocationsVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMapBtn: UIButton!
    
    //var addressArr = [DeliveryDestinations]()
    
    var dropOffLocations = [DropOffLocation]()
    
    var locations = [Location]()
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 10000
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var route: MKRoute!
    var distance: CLLocationDistance = CLLocationDistance()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthStatus()
        
        mapView.delegate = self
        locationManager.delegate = self
        centerMapOnUserLocation()
        
        navigationItem.title = "Delivery Location"
        // Do any additional setup after loading the view.

            for object in dropOffLocations {
                let location = Location.init(title: object.street!, latitude: object.latitude, longitude: object.longitude)
            locations.append(location)
        }
        
//        for location in locations {
//            let annotation = MKPointAnnotation()
//            annotation.title = location.title
//            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//            mapView.addAnnotation(annotation)
//        }
        let annotations = locations.map { location -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            return annotation
        }
        mapView.addAnnotations(annotations)

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
            
                     for (index, element) in locations.enumerated() {
                        if let label = annotationView.numberOfDropsLbl {
                        print("Location \(index + 1): \(element)")
                            label.text = String(index)
                }
            }
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        centerMapBtn.fadeTo(alphaValue: 1.0, withDuration: 0.2)
    }
    
    //creating the line between 2 points working need to move this to different VC
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineRenderer = MKPolylineRenderer(overlay: self.route.polyline)
        lineRenderer.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        lineRenderer.lineWidth = 3

        return lineRenderer
    }
    func searchMapKitForResultsWithPolyline(forMapItem mapItem: MKMapItem) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapItem
        request.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                print(error.debugDescription)
                return
            }
            self.route = response.routes[0]
            self.mapView.add(self.route.polyline)
            self.distance = self.route.distance * 0.00062137
            //print(self.distance)
        }
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

