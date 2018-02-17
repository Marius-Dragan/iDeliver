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
    var nameOrBusiness: String
    var firstLineAddress: String
    var secondLineAddress: String
    var cityLineAddress: String
    var postcodeLineAddress: String
    var distanceToDistance: CLLocationDistance
    var lat: Double
    var long: Double
    var isInTranzit: Bool
    var dateCreated: Date
    

    
    init(NameOrBusiness: String, FirstLineAddress: String, SecondLineAddress: String, CityLineAddress: String, PostCodeLineAddress: String, DistanceToDestination: CLLocationDistance, Lat: Double, Long: Double, isInTranzit: Bool, DateCreated: Date ) {
        self.nameOrBusiness = NameOrBusiness
        self.firstLineAddress = FirstLineAddress
        self.secondLineAddress = SecondLineAddress
        self.cityLineAddress = CityLineAddress
        self.postcodeLineAddress = PostCodeLineAddress
        self.distanceToDistance = DistanceToDestination
        self.lat = Lat
        self.long = Long
        self.isInTranzit = false
        self.dateCreated = DateCreated
       
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
