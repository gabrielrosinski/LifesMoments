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
        if storiesList != nil{
            for story in storiesList {
                storiesArray.append(story)
            }
        }

        //TODO: load shared stories from DB
        let sharedStoriesList = DBManager.sharedInstance.sharedStories
        if sharedStoriesList != nil{
            for sharedStory in sharedStoriesList {
                sharedStoriesArray.append(sharedStory)
            }
        }
    }
    
    func saveDataToDB(){
        DBManager.sharedInstance.saveStoryArrayToDB(storiesArray)
        DBManager.sharedInstance.saveStoryArrayToDB(sharedStoriesArray)
    }
    
    func updateStory(_story:Story){
        for (index,story) in storiesArray.enumerate(){
            if story._storyId == _story._storyId {
                storiesArray.removeAtIndex(index)
                storiesArray.insert(_story, atIndex: index)
            }
        }
    }
    
//    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
//        
//        do {
//            let regex = try NSRegularExpression(pattern: regex, options: [])
//            let nsString = text as NSString
//            let results = regex.matchesInString(text,
//                                                options: [], range: NSMakeRange(0, nsString.length))
//            return results.map { nsString.substringWithRange($0.range)}
//        } catch let error as NSError {
//            print("invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    }
}
