//
//  MomentLocation.swift
//  LifesMoments
//
//  Created by Gabriel on 3/26/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import MapKit

class MomentLocation: NSObject, MKAnnotation{

    var title:     String?
    var subtitle:  String?
    var latitude:  Double
    var longitude: Double
    var type:      Int?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double,type: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
    }
}
