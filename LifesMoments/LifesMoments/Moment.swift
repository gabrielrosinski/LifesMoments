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
    
    dynamic var _date: NSDate = NSDate()
    dynamic var _mediaData: NSData?
    var _storyId: Int = 0
    var _momentID : Int = 0                   //will be deafulty 0 must be changed on every ob creatiob
    var _latitude : Double?
    var _longitude : Double?
    var _mediaType : MediaType?


    
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
