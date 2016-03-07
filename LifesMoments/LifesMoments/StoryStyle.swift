//
//  StoryStyle.swift
//  LifesMoments
//
//  Created by Gabriel on 3/7/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import RealmSwift

class StoryStyle: Object {
    
    dynamic var _font: String?
    dynamic var _backgroundmusic: String?
    dynamic var _transitionStyle: String?
    
    convenience init(font:String, backgroundmusic:String, transitionStylet:String){
        self.init()
        _font = font
        _backgroundmusic = backgroundmusic
        _transitionStyle = transitionStylet
    }
    
}
