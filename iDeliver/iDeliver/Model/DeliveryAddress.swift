//
//  DeliveryAddress.swift
//  iDeliver
//
//  Created by Marius Dragan on 16/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import Foundation
import MapKit

struct DeliveryDestinations {
    var NameOrBusiness: String?
    var FirstLineAddress: String?
    var SecondLineAddress: String?
    var CityLineAddress: String?
    var PostcodeLineAddress: String?
    var DistanceToDestination: CLLocationDistance?
    var Lat: Double?
    var Long: Double?

    
    init(NameOrBusiness: String?, FirstLineAddress: String?, SecondLineAddress: String?, CityLineAddress: String?, PostCodeLineAddress: String?, DistanceToDestination: CLLocationDistance?, Lat: Double?, Long: Double? ) {
        self.NameOrBusiness = NameOrBusiness
        self.FirstLineAddress = FirstLineAddress
        self.SecondLineAddress = SecondLineAddress
        self.CityLineAddress = CityLineAddress
        self.PostcodeLineAddress = PostCodeLineAddress
        self.DistanceToDestination = DistanceToDestination
        self.Lat = Lat
        self.Long = Long
       
    }
    
}

struct Location {
    let title: String
    let latitude: Double
    let longitude: Double
    
    init(title: String, latitude: Double, longitude: Double) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
}
