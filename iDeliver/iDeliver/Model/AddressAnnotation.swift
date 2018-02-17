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
    var address: String!
    var dropNumber: String!
    var image: UIImage!
    var toBeTapped: Bool = false
    var selected: Bool = false
    //var key: String
    
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        //super.init()
    }
}
