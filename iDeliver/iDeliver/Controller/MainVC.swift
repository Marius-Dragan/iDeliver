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
    
    var customCell: AddressCell = AddressCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryAddress.delegate = self
        deliveryAddress.dataSource = self
        deliveryAddress.reloadData()
    }
    
    func userDidEnterData(firstAddress: String, secondAddress: String, cityAddress: String, postcodeAddress: String) {
        customCell.firstLineAddressLbl?.text = firstAddress
        customCell.secondLineAddressLbl?.text = secondAddress
        customCell.cityLineAddressLbl?.text = cityAddress
        customCell.postcodeLineAddressLbl?.text = postcodeAddress
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddressCell", for: indexPath) as! AddressCell
        cell.updateUI()
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeliveryAddressVC" {
            let addDestination:AddingDestinationVC = segue.destination as! AddingDestinationVC
            addDestination.delegate = self
    }
    
  
}
    
}

