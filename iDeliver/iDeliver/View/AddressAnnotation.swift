//
//  AddressAnnotation.swift
//  iDeliver
//
//  Created by Marius Dragan on 17/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import Foundation
import MapKit

class AddressAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    //var key: String
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
