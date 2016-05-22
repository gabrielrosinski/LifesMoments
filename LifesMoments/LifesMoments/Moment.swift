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
import ObjectMapper

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
    dynamic var _mediaData: NSData = NSData()
    dynamic var _storyId: String = ""
    dynamic var _momentID: Int = 0
    dynamic var _mediaType: Int = 0
    dynamic var _latitude: Double = 0.0
    dynamic var _longitude: Double = 0.0
                     //init value for some reason if its nil it wont rewrite it

    override static func primaryKey() -> String? {
        return "_momentID"
    }
    
    func getMomentDict() -> [String : AnyObject]{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(self._date)
        
        let momentDataAsHex = hexString(self._mediaData)
        
        let momentDict:[String:AnyObject] = ["Date":dateString,
                                             "Data":momentDataAsHex,
                                             "StoryId": self._storyId,
                                             "MomentID":self._momentID,
                                             "Longitude":self._longitude,
                                             "Latitude":self._latitude,
                                             "MediaType":self._mediaType]
        
        return momentDict
        
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self._date = (decoder.decodeObjectForKey("_date") as? NSDate)!
        self._mediaData = (decoder.decodeObjectForKey("_mediaData") as? NSData)!
        self._storyId = (decoder.decodeObjectForKey("_storyId") as? String)!
        self._momentID = (decoder.decodeObjectForKey("_momentID") as? Int)!
        self._mediaType = (decoder.decodeObjectForKey("_mediaType") as? Int)!
        self._latitude = (decoder.decodeObjectForKey("_latitude") as? Double)!
        self._longitude = (decoder.decodeObjectForKey("_longitude") as? Double)!
    }

    
    
    func hexString(data:NSData)->String{
        if data.length > 0 {
            let  hexChars = Array("0123456789abcdef".utf8) as [UInt8];
            let buf = UnsafeBufferPointer<UInt8>(start: UnsafePointer(data.bytes), count: data.length);
            var output = [UInt8](count: data.length*2 + 1, repeatedValue: 0);
            var ix:Int = 0;
            for b in buf {
                let hi  = Int((b & 0xf0) >> 4);
                let low = Int(b & 0x0f);
                output[ix++] = hexChars[ hi];
                output[ix++] = hexChars[low];
            }
            let result = String.fromCString(UnsafePointer(output))!;
            return result;
        }
        return "";
    }
    
    ////    to use this init it must be initiliazde with params
    //    convenience init(storyId:String){
    //        self.init()
    //        //self._name = name
    //  
    //    }
}
