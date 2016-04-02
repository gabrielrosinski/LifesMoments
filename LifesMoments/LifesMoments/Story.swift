//
//  Story.swift
//  LifesMoments
//
//  Created by Gabriel on 3/7/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Story: Object {

    var _storyId: Int = 0                   //will be deafulty 0 must be changed on every ob creatiob
    dynamic var _userId: String?
    var  _startLatitude: Double?
    var  _startLongitude: Double?
    var  _endLatitude: Double?
    var  _endLongitude: Double?
    var _sharedStory: Bool = false
    var _momentsList = List<Moment>()
    var _style: StoryStyle? = StoryStyle()
    var  _curentMomentID  : Int = 0
    
    


//    convenience init(storyId: String, userId: String, startLocation: CLLocation, endLocation: CLLocation, momentsList:List<Moment>, style: StoryStyle){
//        self.init()
//        
//        self._storyId = storyId
//        self._userId = userId
//        self._startLocation = startLocation
//        self._endLocation = endLocation
//        self._momentsList = momentsList
//        self._style = style
//        
//    }
    
    
    override static func primaryKey() -> String? {
        return "_storyId"
    }
    
}
