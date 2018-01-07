//
//  MaterialView.swift
//  iDeliver
//
//  Created by Marius Dragan on 07/01/2018.
//  Copyright © 2018 Marius Dragan. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {

    @IBInspectable var materialDesign: Bool {
        
        get {
                return materialKey
        }
        set  {
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false //carefull when using this, do not use this on the tableView. Use only on custom cell
                self.layer.cornerRadius = 5.0
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 4.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
                self.layer.shadowColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)//UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            
            } else {
                
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }
}
