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

    dynamic var _date: NSDate?
    dynamic var _message: String?
    dynamic var _userId: String?
    dynamic var _storyId: String?
    
    convenience init(message:String, userId:String, storyId:String, date: NSDate){
        self.init()
        _message = message
        _userId = userId
        _storyId = storyId
        _date = date
    }
}
