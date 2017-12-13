//
//  AddingDestination.swift
//  iDeliver
//
//  Created by Marius Dragan on 12/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(data: String)
}

class AddingDestination: UIViewController {

    @IBOutlet weak var firstLineAddressTextField: UITextField!
    @IBOutlet weak var secondLineAddressTextField: UITextField!
    @IBOutlet weak var cityLineAddressTextField: UITextField!
    @IBOutlet weak var postcodeLineAddressTextField: UITextField!
    
    var delegate:DataSentDelegate! = nil
    
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
                delegate?.userDidEnterData(data: firstLineAddress!)
                delegate?.userDidEnterData(data: secondLineAddress!)
                delegate?.userDidEnterData(data: cityLineAddress!)
                delegate?.userDidEnterData(data: postcodeLineAddress!)
                dismiss(animated: true, completion: nil)
        }
    }
    
}
}

