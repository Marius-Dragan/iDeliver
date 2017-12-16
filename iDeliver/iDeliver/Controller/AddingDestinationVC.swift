//
//  AddingDestination.swift
//  iDeliver
//
//  Created by Marius Dragan on 12/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    //Replace parameter with DeliveryDestinations
    func userDidEnterData(addressObj: DeliveryDestinations)
}

class AddingDestinationVC: UIViewController {

    @IBOutlet weak var firstLineAddressTextField: UITextField!
    @IBOutlet weak var secondLineAddressTextField: UITextField!
    @IBOutlet weak var cityLineAddressTextField: UITextField!
    @IBOutlet weak var postcodeLineAddressTextField: UITextField!
    
    var delegate: DataSentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func addBtnWasPressed(_ sender: Any) {
        if delegate != nil {
            if firstLineAddressTextField.text != nil {
                //Create Model object DeliveryDestinations
                let addressObj = DeliveryDestinations(FirstLineAddress: firstLineAddressTextField.text, SecondLineAddress: secondLineAddressTextField.text, CityLineAddress: cityLineAddressTextField.text, PostCodeLineAddress: postcodeLineAddressTextField.text)
                //add that object to previous view with delegate
                delegate?.userDidEnterData(addressObj: addressObj)
                navigationController?.popViewController(animated: true)
            }
        }
    
    }
}

