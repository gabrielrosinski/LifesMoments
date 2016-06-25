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
    var backgroundTrack:Int = 0
    
    
    //TODO: when i get new story from FB it needs to be appended here too
    
    override init() {
        super.init()
        fetchStoriesFromDB()
    }
    
    func whichTrackToPlay() -> String {
      return getBackGroundTrack(self.backgroundTrack)
    }
    
    func getBackGroundTrack(trackNumber:Int) -> String
    {
        let acoustic = NSBundle.mainBundle().pathForResource("backTrack", ofType: "mp3")!
        let rock = NSBundle.mainBundle().pathForResource("rock", ofType: "mp3")!
        let epic = NSBundle.mainBundle().pathForResource("epic", ofType: "mp3")!
        
        var dict:[Int:String] = [0 : acoustic , 1 : rock , 2 : epic]
        
        return dict[trackNumber]!
    }
    
    func setBackGroundTrack(trackNumber:Int)
    {
        self.backgroundTrack = trackNumber
    }
    
    func fetchStoriesFromDB(){
        let storiesList = DBManager.sharedInstance.myStories
        if storiesList != nil && (storiesArray.isEmpty == true){
            for story in storiesList {
                storiesArray.append(story)
            }
        }
        
        let sharedStoriesList = DBManager.sharedInstance.sharedStories
        if sharedStoriesList != nil && (sharedStoriesArray.isEmpty == true){
            for sharedStory in sharedStoriesList {
                sharedStoriesArray.append(sharedStory)
            }
        }
    }
    
    func fetchUpdatedStories(){
        storiesArray.removeAll()
        sharedStoriesArray.removeAll()
        DBManager.sharedInstance.loadAllStories()
        fetchStoriesFromDB()
        DBManager.sharedInstance.delegate?.newSharedStorySavedInDB()
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
    

    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [],
                                                range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
