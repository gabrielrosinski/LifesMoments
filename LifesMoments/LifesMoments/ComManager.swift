//
//  ComManager.swift
//  LifesMoments
//
//  Created by Gabriel on 3/5/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

let kUsersUrl:String = "https://lifes-moments.herokuapp.com/api/users"
let kStoryUrl:String = "https://lifes-moments.herokuapp.com/api/story"
let kStoryByIDUrl:String = "https://lifes-moments.herokuapp.com/api/story/api/story/$id"    //replace the $id with its int


class ComManager: NSObject {
    
    static let sharedInstance = ComManager()
    private override init() {
     
    }

    
    /**
     if json["message"] == User exist! user name exists
     else json["message"] is equle "User Created!" and json["hash"] has value
     
     the server will create the user on the go
     
     the method will return User exist! incase the it exists user is create new user other wise
    */
    func createNewUser(userName: String, password: String, completion: (result :String) -> Void)
    {
        
        var message: String = ""
        
        //example on how to do it
        let parameters = [
            "name" : userName,
            "password" : password
        ]
        
        Alamofire.request(.POST, kUsersUrl, parameters: parameters)
            .response { request, response, data, error in
                //                        print(request)
                //                        print(response)
                //                        print(data)
                //                        print(error)
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                    message = json["message"] as! String
                    completion(result: message)
                } catch {
                    print("json error: \(error)")
                }
        }
    }
    


    func publishStory(story : Story)
    {
        
    }
    
    func downloadSharedStory()
    {
        
    }
    
    func sendComment(newComment : Comment)
    {
        
    }
    
    func getNewComments(storyId : Int) -> [Int : String]    //this will retun comments dict [comments id : message]
    {
        
        Alamofire.request(.GET, "https://lifes-moments.herokuapp.com/api/", parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                
                if let JSON = response.result.value {
                    
                    var tid: Int?
//                    if let types = JSON["employees"] as? NSArray {
//                        
//                        for obj in types {
//                            print(obj["firstName"] as! String)
//                            print(obj["lastName"] as! String)
//                        }
//                        
//                        
//                        
//                        //                        for type in types {
//                        //                            if let dict = types.lastObject as? NSDictionary {
//                        //                                tid = dict["TID"] as? Int
//                        //                                if tid != nil {
//                        //                                    break
//                        //                                }
//                        //                            }
//                        //                        }
//                        
//                        
//                    }
                }
        }
        
        return [1 : "Stab"]
    }

    
    func sendRating(userid : Int)   //this will act a flag //need to change the int to hash returned from the server
    {
        
    }
    
}
