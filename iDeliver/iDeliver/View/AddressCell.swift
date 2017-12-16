//
//  AddressCell.swift
//  iDeliver
//
//  Created by Marius Dragan on 10/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var firstLineAddressLbl: UILabel!
    @IBOutlet weak var secondLineAddressLbl: UILabel!
    @IBOutlet weak var cityLineAddressLbl: UILabel!
    @IBOutlet weak var postcodeLineAddressLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var metricLbl: UILabel!
   
    func updateUI(addressObj: DeliveryDestinations) {
        
        //Drow your cell with values from addressObj
        firstLineAddressLbl.text = addressObj.FirstLineAddress
        secondLineAddressLbl.text = addressObj.SecondLineAddress
        cityLineAddressLbl.text = addressObj.CityLineAddress
        postcodeLineAddressLbl.text = addressObj.PostcodeLineAddress
        
    }
}

