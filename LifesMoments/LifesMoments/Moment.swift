//
//  Moment.swift
//  LifesMoments
//
//  Created by Gabriel on 3/7/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation



class Moment: Object {
    
    enum MediaType: Int {
        case picture = 0
        case video = 1
        case audio = 2
        case text = 3
    }
    
    dynamic var _date: NSDate?
    dynamic var _storyId: String?
    dynamic var _mediaData: NSData?
    dynamic var _location : CLLocation?
    var _mediaType : MediaType?
    var _momentID : Int?

    
//    to use this init it must be initiliazde with params
    convenience init(storyId:String){
        self.init()
        //self._name = name
  
    }
}
