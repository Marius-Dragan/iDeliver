//
//  ViewController.swift
//  iDeliver
//
//  Created by Marius Dragan on 26/11/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DataSentDelegate {
    var customTableViewCell = AddressCell()
    

    

    @IBOutlet weak var deliveryAddress: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryAddress.delegate = self
        deliveryAddress.dataSource = self
        deliveryAddress.reloadData()
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddressCell", for: indexPath) as! AddressCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeliveryAddress" {
            let addDestination:AddingDestination = segue.destination as! AddingDestination
            addDestination.delegate = self
    }
    
  
}
    func userDidEnterData(data: String) {
        customTableViewCell.firstLineAddressLbl?.text = data
        customTableViewCell.secondLineAddressLbl?.text = data
        customTableViewCell.cityLineAddressLbl?.text = data
        customTableViewCell.postcodeLineAddressLbl?.text = data
    }
}
