//
//  DBManager.swift
//  LifesMoments
//
//  Created by Gabriel on 3/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager: NSObject {

    static let sharedInstance = DBManager()
    private override init() {
        
    }
    
    
    func saveUserToDB(user: User)
    {
        
    }
    
    func fetchAllStories(userName: String) -> [Int : AnyObject]
    {
        return [6 : "stab"]
    }
    
    func saveStoryToDB(story: Story)
    {
        
    }
    
    func fetchStoryForUserName(userName: String) -> [Int : AnyObject]
    {
        return [6 : "stab"]
    }
    
    //TODO: do we need to save the comments ?
    
}
