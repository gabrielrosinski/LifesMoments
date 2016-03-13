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
    
    var currentUser   : Results<User>!
    var myStories     : Results<Story>!
    var sharedStories : Results<Story>!     //might not need this. can filter from the one returned list
    var storyComments : Results<Comment>!
    
    private override init()
    {

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
    
    func loadUserFromDB(userID:String) -> User?
    {
        currentUser = realm.objects(User).filter("_userName == %@", userID)
        
//        currentUser = realm.objects(User)
        
        let user =  currentUser.first
        
        return user //user!//User()
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




//singelton example
/*
class TheOneAndOnlyKraken {
static let sharedInstance = TheOneAndOnlyKraken()
private init() {} //This prevents others from using the default '()' initializer for this class.
}
*/