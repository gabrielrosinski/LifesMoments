//
//  DataManager.swift
//  LifesMoments
//
//  Created by Gabriel on 3/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    static let sharedInstance = DataManager()
    
    var storiesArray: [Story] = [Story]()
    var sharedStoriesArray: [Story] = [Story]()
    
    
    //TODO: when i get new story from FB it needs to be appended here too
    
    override init() {
        //DBManager.sharedInstance.realm
        
        let storiesList = DBManager.sharedInstance.myStories
        for story in storiesList {
            storiesArray.append(story)
        }
        
        //TODO: load shared stories from DB
        let sharedStoriesList = DBManager.sharedInstance.sharedStories
        for sharedStory in sharedStoriesList {
            sharedStoriesArray.append(sharedStory)
        }
    }
    
    func saveDataToDB(){
        DBManager.sharedInstance.saveStoryArrayToDB(storiesArray)
        DBManager.sharedInstance.saveStoryArrayToDB(sharedStoriesArray)
    }
    
}
