//
//  ViewController.swift
//  iDeliver
//
//  Created by Marius Dragan on 26/11/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DataSentDelegate {
    
    @IBOutlet weak var deliveryAddress: UITableView!
    
    //Create array which will return your address data
    var addressArr = [DeliveryDestinations]()

    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryAddress.delegate = self
        deliveryAddress.dataSource = self
        deliveryAddress.reloadData()
    }
    
    //add parameter for created address object
    func userDidEnterData(addressObj: DeliveryDestinations) {
        
        //append added object into your table array
        self.addressArr.append(addressObj)
        //Reload your tableview once your new object added.
        self.deliveryAddress.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //change this with array count
        return addressArr.count
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddressCell", for: indexPath) as! AddressCell
        //get address object from array which you can assign to cell
        let addressObj = addressArr[indexPath.row]
        //assign data from array
        cell.updateUI(addressObj: addressObj)
        cell.numberLbl.text = String(indexPath.row + 1)
        return cell
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeliveryAddressVC" {
            let barBtm = UIBarButtonItem()
            barBtm.title = ""
            navigationItem.backBarButtonItem = barBtm
            let addDestination:AddingDestinationVC = segue.destination as! AddingDestinationVC
            addDestination.delegate = self
        } else if segue.identifier == "deliveryLocationVC" {
                let barBtm2 = UIBarButtonItem()
                barBtm2.title = ""
                navigationItem.backBarButtonItem = barBtm2
            if let deliveryLocationVC = segue.destination as? DeliveryLocationsVC {
                deliveryLocationVC.addressArr = addressArr
                }
            }
        }
    }



