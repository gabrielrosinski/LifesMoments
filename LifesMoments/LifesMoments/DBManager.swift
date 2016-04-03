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

    let realm = try! Realm()
    static let sharedInstance = DBManager()
    
    var currentUserList   : Results<User>!
    var myStories         : Results<Story>!
    var sharedStories     : Results<Story>!     //might not need this. can filter from the one returned list
    var storyComments     : Results<Comment>!
    
    var currentUser: User?
    
    
    private override init()
    {
//        var config = realm.configuration
//        config.schemaVersion = 2
//        config.migrationBlock = { (migration, oldSchemaVersion) in
//            // nothing to do
//        }
//        Realm.Configuration.defaultConfiguration = config
    }
    
    
    func saveUserToDB(user: User)
    {
        do{
            try realm.write({ () -> Void in
                realm.add(user)

                print(user)
            })
        }catch{
            print("error trying to save new user")
        }
    }
    
    func saveCurrentUserTODB() {
        do{
            try realm.write({ () -> Void in
                realm.add(currentUser!, update: true)
            })
        }catch{
            print("error trying to save new user")
        }
    }
    
    func loadUserFromDB(userID:String) -> User?
    {
        currentUserList = realm.objects(User).filter("_userName == %@", userID)
        currentUser =  currentUserList.first
        return currentUser //user!//User()
    }
    
    func loadAllStories()
    {
        myStories = realm.objects(Story).filter("_sharedStory == %@ AND _userId == %@ ",false, (currentUser?._userName)!)
        sharedStories = realm.objects(Story).filter("_sharedStory == %@ AND _userId == %@ ",true, (currentUser?._userName)!)
    }
    
    func saveStoryToDB(story: Story)
    {
        do{
            try realm.write({ () -> Void in
                realm.add(story, update: true)
            })
        }catch{
            print("error trying to save new user")
        }
    }
    
    
    func saveStoryArrayToDB(storyArray:[Story]) {
        for story in storyArray {
            saveStoryToDB(story)
        }
    }
    
    
    func deleteStory(story: Story){
        try! realm.write {
            realm.delete(story)
        }
    }
    
    
    
    func fetchStoryForUserName(userName: String) -> [Int : AnyObject]
    {
        return [6 : "stab"]
    }
    
    //TODO: do we need to save the comments ?
    
}




//singelton example
/*
class TheOneAndOnlyKraken {
static let sharedInstance = TheOneAndOnlyKraken()
private init() {} //This prevents others from using the default '()' initializer for this class.
}
*/