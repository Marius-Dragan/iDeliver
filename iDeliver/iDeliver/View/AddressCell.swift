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
    @IBOutlet weak var metricLbl: UILabel!
   
    func updateUI(addressObj: DeliveryDestinations) {
        
        //Drow the cell with values from addressObj
        nameOrBusinessLbl.text = addressObj.NameOrBusiness
        firstLineAddressLbl.text = addressObj.FirstLineAddress
        countryLineAddressLbl.text = addressObj.SecondLineAddress
        cityLineAddressLbl.text = addressObj.CityLineAddress
        postcodeLineAddressLbl.text = addressObj.PostcodeLineAddress
        distanceLbl.text = String(format: "%.2f ", addressObj.DistanceToDestination)
        
    }
}

