//
//  AddressCell.swift
//  iDeliver
//
//  Created by Marius Dragan on 10/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var firstLineAddresLbl: UILabel!
    @IBOutlet weak var secondLineAddressLbl: UILabel!
    @IBOutlet weak var cityLineAddressLbl: UILabel!
    @IBOutlet weak var postcodeLineAddressLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var metricLbl: UILabel!
    
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    

}
