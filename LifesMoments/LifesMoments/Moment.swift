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
//import ObjectMapper

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
    
    convenience init(momentJsonStr: [String : AnyObject]) {
        self.init()
        
        //date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self._date = dateFormatter.dateFromString((momentJsonStr["Date"] as? String)!)!
        
        //data
        let dataStr = momentJsonStr["Data"] as? String
        self._mediaData = (dataStr?.dataFromHexadecimalString()!)!
        
        self._latitude = Double((momentJsonStr["Latitude"] as? String)!)!
        self._longitude = Double((momentJsonStr["Longitude"] as? String)!)!
        self._momentID = Int((momentJsonStr["MomentID"] as? String)!)!
        self._mediaType = Int((momentJsonStr["MediaType"] as? String)!)!
        self._storyId = (momentJsonStr["StoryId"] as? String)!
        
    }
    
    
//    required convenience init(coder decoder: NSCoder) {
//        self.init()
//        self._date = (decoder.decodeObjectForKey("_date") as? NSDate)!
//        self._mediaData = (decoder.decodeObjectForKey("_mediaData") as? NSData)!
//        self._storyId = (decoder.decodeObjectForKey("_storyId") as? String)!
//        self._momentID = (decoder.decodeObjectForKey("_momentID") as? Int)!
//        self._mediaType = (decoder.decodeObjectForKey("_mediaType") as? Int)!
//        self._latitude = (decoder.decodeObjectForKey("_latitude") as? Double)!
//        self._longitude = (decoder.decodeObjectForKey("_longitude") as? Double)!
//    }

    
    
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

    
}

extension String {
    
    /// Create NSData from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a NSData object. Note, if the string has any spaces, those are removed. Also if the string started with a '<' or ended with a '>', those are removed, too. This does no validation of the string to ensure it's a valid hexadecimal string
    ///
    /// The use of `strtoul` inspired by Martin R at http://stackoverflow.com/a/26284562/1271826
    ///
    /// - returns: NSData represented by this hexadecimal string. Returns nil if string contains characters outside the 0-9 and a-f range.
    
    func dataFromHexadecimalString() -> NSData? {
        let trimmedString = self.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<> ")).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // make sure the cleaned up string consists solely of hex digits, and that we have even number of them
        
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: .CaseInsensitive)
        
        let found = regex.firstMatchInString(trimmedString, options: [], range: NSMakeRange(0, trimmedString.characters.count))
        if found == nil || found?.range.location == NSNotFound || trimmedString.characters.count % 2 != 0 {
            return nil
        }
        
        // everything ok, so now let's build NSData
        
        let data = NSMutableData(capacity: trimmedString.characters.count / 2)
        
        for var index = trimmedString.startIndex; index < trimmedString.endIndex; index = index.successor().successor() {
            let byteString = trimmedString.substringWithRange(Range<String.Index>(start: index, end: index.successor().successor()))
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.appendBytes([num] as [UInt8], length: 1)
        }
        
        return data
    }
}
