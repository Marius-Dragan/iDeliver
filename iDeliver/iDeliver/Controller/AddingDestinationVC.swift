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

class AddingDestinationVC: UIViewController, UITextFieldDelegate {

    //IBOutles
    
    @IBOutlet weak var firstLineAddressTextField: UITextField!
    @IBOutlet weak var secondLineAddressTextField: UITextField!
    @IBOutlet weak var cityLineAddressTextField: UITextField!
    @IBOutlet weak var postcodeLineAddressTextField: UITextField!
    
    var delegate: DataSentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLineAddressTextField.delegate = self
        secondLineAddressTextField.delegate = self
        cityLineAddressTextField.delegate = self
        postcodeLineAddressTextField.delegate = self

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Add Destination"
        func textFieldShouldClear(textField: UITextField) -> Bool {
            firstLineAddressTextField.text = " "
            secondLineAddressTextField.text = " "
            cityLineAddressTextField.text = " "
            postcodeLineAddressTextField.text = " "
            return true
        }
    }
    @IBAction func addBtnWasPressed(_ sender: Any) {
         if delegate != nil {
        if firstLineAddressTextField.text != "" && cityLineAddressTextField.text != "" && postcodeLineAddressTextField.text != "" {
            
                //Create Model object DeliveryDestinations
                let addressObj = DeliveryDestinations(FirstLineAddress: firstLineAddressTextField.text, SecondLineAddress: secondLineAddressTextField.text, CityLineAddress: cityLineAddressTextField.text, PostCodeLineAddress: postcodeLineAddressTextField.text)
                //add that object to previous view with delegate
                delegate?.userDidEnterData(addressObj: addressObj)
                //Dismising VC
                //navigationController?.popViewController(animated: true)
            firstLineAddressTextField.text = " "
            secondLineAddressTextField.text = " "
            cityLineAddressTextField.text = " "
            postcodeLineAddressTextField.text = " "
            }
    
        }
    }
}

