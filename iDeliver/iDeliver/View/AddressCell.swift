//
//  AddressCell.swift
//  iDeliver
//
//  Created by Marius Dragan on 10/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var nameOrBusinessLbl: UILabel!
    @IBOutlet weak var firstLineAddressLbl: UILabel!
    @IBOutlet weak var cityLineAddressLbl: UILabel!
    @IBOutlet weak var postcodeLineAddressLbl: UILabel!
    @IBOutlet weak var countryLineAddressLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var distanceLbl: UILabel!

    
    
    //func configureCell(addressObj: DeliveryDestinations) {
    func configureCell(dropOffLocation: DropOffLocation) {
        
        //Drow the cell with values from addressObj
        nameOrBusinessLbl.text = dropOffLocation.nameOrBusiness
        firstLineAddressLbl.text = dropOffLocation.street
        countryLineAddressLbl.text = dropOffLocation.country
        cityLineAddressLbl.text = dropOffLocation.city
        postcodeLineAddressLbl.text = dropOffLocation.postcode
        distanceLbl.text = String(format: "%.2f ", dropOffLocation.distance)
        
    }
}

