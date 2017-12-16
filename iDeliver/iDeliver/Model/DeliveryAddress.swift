//
//  DeliveryAddress.swift
//  iDeliver
//
//  Created by Marius Dragan on 16/12/2017.
//  Copyright © 2017 Marius Dragan. All rights reserved.
//

import Foundation

struct DeliveryDestinations {
    var FirstLineAddress: String?
    var SecondLineAddress: String?
    var CityLineAddress: String?
    var PostcodeLineAddress: String?
    
    init(FirstLineAddress: String? , SecondLineAddress: String?, CityLineAddress: String?, PostCodeLineAddress: String?) {
        self.FirstLineAddress = FirstLineAddress
        self.SecondLineAddress = SecondLineAddress
        self.CityLineAddress = CityLineAddress
        self.PostcodeLineAddress = PostCodeLineAddress
    }
    
}
