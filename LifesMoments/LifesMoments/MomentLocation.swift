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

    dynamic var title:     String?
    dynamic var subtitle:  String?
    dynamic var latitude:  Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var type:      Int = 0
    dynamic var momentID:  Int = 0
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, type: Int, momentId: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.momentID = momentId
    }
}
