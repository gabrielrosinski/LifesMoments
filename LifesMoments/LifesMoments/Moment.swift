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

enum MediaType: Int {
    case picture = 0
    case video = 1
    case audio = 2
    case text = 3
}

//realm cant presist eunms so will use regualr raw values
//this is there meening
/*
  picture = 0
  video = 1
  audio = 2
  text = 3
*/

class Moment: Object {
    
    dynamic var _date: NSDate = NSDate()
    dynamic var _mediaData: NSData?
    dynamic var _storyId: String?
    dynamic var _momentID: Int = 0
    dynamic var _latitude: Double = 0.0
    dynamic var _longitude: Double = 0.0
    dynamic var _mediaType: Int = 0                  //init value for some reason if its nil it wont rewrite it

    
    
////    to use this init it must be initiliazde with params
//    convenience init(storyId:String){
//        self.init()
//        //self._name = name
//  
//    }
    override static func primaryKey() -> String? {
        return "_momentID"
    }
    
}
