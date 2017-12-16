//
//  AddingDestination.swift
//  iDeliver
//
//  Created by Marius Dragan on 12/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(firstAddress: String, secondAddress: String, cityAddress: String, postcodeAddress: String)
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
                 let firstLineAddress = firstLineAddressTextField.text
                print(firstLineAddress as Any)
                let secondLineAddress = secondLineAddressTextField.text
                let cityLineAddress = secondLineAddressTextField.text
                let postcodeLineAddress = postcodeLineAddressTextField.text
                delegate?.userDidEnterData(firstAddress: firstLineAddress!, secondAddress: secondLineAddress!, cityAddress: cityLineAddress!, postcodeAddress: postcodeLineAddress!)
                navigationController?.popViewController(animated: true)
        }
    }
    
}
}

