//
//  StartRouteButton.swift
//  iDeliver
//
//  Created by Marius Dragan on 13/01/2018.
//  Copyright © 2018 Marius Dragan. All rights reserved.
//

import UIKit

class StartRouteButton: UIButton {

    override var titleLabel: UILabel?  {
        get {
            let label = super.titleLabel
            label?.font = UIFont(name: "AvenirNext-DemiBold", size: 25)!
            return label
        }
    }

}
