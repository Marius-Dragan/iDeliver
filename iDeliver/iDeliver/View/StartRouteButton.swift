//
//  StartRouteButton.swift
//  iDeliver
//
//  Created by Marius Dragan on 13/01/2018.
//  Copyright © 2018 Marius Dragan. All rights reserved.
//

import UIKit

class StartRouteButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }
    
    private func configureButton() {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 25)!
        self.layer.cornerRadius = 2.5
//        if titleLabel?.text == "IN TRANZIT" { //<-- not too sure if this works
//            self.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 0.75)
//        }
    }
}
