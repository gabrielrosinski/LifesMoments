//
//  Comment.swift
//  LifesMoments
//
//  Created by Gabriel on 3/7/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import RealmSwift

class Comment: Object {

    dynamic var _date:      NSDate = NSDate()
    dynamic var _message:   String = ""
    var _userId:            Int?
    var _storyId:           Int?
//    var _commentId:         Int?
    
//    convenience init(message:String, userId:String, storyId:String, date: NSDate){
//        self.init()
//        _message = message
//        _userId = userId
//        _storyId = storyId
//        _date = date
//    }
    
    
//    override static func primaryKey() -> String? {
//        return "_commentId"
//    }
}
