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

    dynamic var  _storyId: String?                   //will be deafulty 0 must be changed on every ob creatiob
    dynamic var  _userId: String?
    dynamic var  _startLatitude: Double = 0.0
    dynamic var  _startLongitude: Double = 0.0
    dynamic var  _endLatitude: Double = 0.0
    dynamic var  _endLongitude: Double = 0.0
    dynamic var  _sharedStory: Bool = false
    dynamic var  _curentMomentID  : Int = 0
    var _momentsList = List<Moment>()
    var _style: StoryStyle? = StoryStyle()
    
    
    


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
