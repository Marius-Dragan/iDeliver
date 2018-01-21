//
//  CustomAnnotationView.swift
//  iDeliver
//
//  Created by Marius Dragan on 20/01/2018.
//  Copyright © 2018 Marius Dragan. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {

    var numberOfDropsLbl: UILabel?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
