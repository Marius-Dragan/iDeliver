//
//  ViewController.swift
//  iDeliver
//
//  Created by Marius Dragan on 26/11/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit
import CoreData
import RevealingSplashView
import MapKit
import CoreLocation

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    //Create array which will return your address data
    var originalArr = [DeliveryDestinations]()
    var addressArr = [DeliveryDestinations]()
    var dropOffLocations = [DropOffLocation]()
        var locations = [Location]()
    
    let revealingSplashView = RevealingSplashView (iconImage: UIImage(named: "LaunchScreenIcon")!, iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        //tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                if dropOffLocations.count >= 1 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }

    @IBAction func segmentChange(_ sender: Any) {
        fetch { (true) in
            tableView.reloadData()
        }
    }
    @objc func tappedButton(sender : Any){
           // let locations = Location.init(title: object.street!, latitude: object.latitude, longitude: object.longitude)
            //let locations = dropOffLocations[(sender as AnyObject).tag]
        let locations = dropOffLocations[sender]
            print(locations)
            let destinationCoordinate = CLLocationCoordinate2D(latitude: locations.latitude, longitude: locations.longitude)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            destinationMapItem.name = "Delivery Destination"
            destinationMapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
   // @IBAction func startRouteBtnWasPressed(_ sender: Any) {
//            for object in dropOffLocations {
//
//                let locations = Location.init(title: object.street!, latitude: object.latitude, longitude: object.longitude)
//                print(locations)
//                let destinationCoordinate = CLLocationCoordinate2D(latitude: locations.latitude, longitude: locations.longitude)
//                let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
//                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//                destinationMapItem.name = locations.title
//                destinationMapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
//            }
//}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeliveryAddressVC" {
            let barBtm = UIBarButtonItem()
            barBtm.title = ""
            navigationItem.backBarButtonItem = barBtm
            let addDestination:AddingDestinationVC = segue.destination as! AddingDestinationVC

        } else if segue.identifier == "deliveryLocationVC" {
            let barBtm2 = UIBarButtonItem()
            barBtm2.title = ""
            navigationItem.backBarButtonItem = barBtm2
            if let deliveryLocationVC = segue.destination as? DeliveryLocationsVC {
                //deliveryLocationVC.addressArr = addressArr
                deliveryLocationVC.dropOffLocations = dropOffLocations
                }
            }
        }
    }

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220 // modify the size of cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //change this with array count
//        return addressArr.count // without coreData
                    return dropOffLocations.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddressCell", for: indexPath) as? AddressCell else { return UITableViewCell() }
//        //get address object from array which you can assign to cell
//        let addressObj = addressArr[indexPath.row] // without coreData
//        //assign data from array
//        cell.configureCell(addressObj: addressObj) // without coreData
//        cell.numberLbl.text = String(indexPath.row + 1) // without coreData
       
        let dropOffLocation = dropOffLocations[indexPath.row]
        let tapGesture = UITapGestureRecognizer(target: MainVC.self, action: Selector(("tappedButton")))
        cell.addGestureRecognizer(tapGesture)
        cell.startBtn.tag = indexPath.row
       // cell.startBtn.addTarget(self, action: #selector(self.tappedButton(sender:)), for: .touchUpInside)
        cell.configureCell(dropOffLocation: dropOffLocation)
        cell.numberLbl.text = String(indexPath.row + 1)

        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeDropOffLocation(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let completeAction = UITableViewRowAction(style: .normal, title: "DELIVERED") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        completeAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return [deleteAction, completeAction]
    }
}

extension MainVC {
    
    func setProgress(atIndexPath indexPath: IndexPath) {
              guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenLocation = dropOffLocations[indexPath.row]
        //to create conditional code to trigger the complete delivered view on top of cell
        
    }
    
    func removeDropOffLocation (atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(dropOffLocations[indexPath.row])
        
        do {
            try managedContext.save()
            print("Succesfully removed delivery location!")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetch (completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<DropOffLocation>(entityName: "DropOffLocation")
        
        let sortByAdded = NSSortDescriptor(key: "dateCreated", ascending: true)
        let sortByDistance = NSSortDescriptor(key: "distance", ascending: true)
        let sortByPostcode = NSSortDescriptor(key: "postcode", ascending: true)
        
        if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [sortByAdded]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [sortByDistance]
        } else if segment.selectedSegmentIndex == 3 {
            fetchRequest.sortDescriptors = [sortByPostcode]
        }
        
        do {
            dropOffLocations = try managedContext.fetch(fetchRequest) 
            print("Succesfully fetched data!")
            completion(true)
        } catch {
            debugPrint("Could not fetch \(error.localizedDescription)")
            completion(false)
        }
    }
}
