//
//  Alertable.swift
//  iDeliver
//
//  Created by Marius Dragan on 30/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func showAlert(_ msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
