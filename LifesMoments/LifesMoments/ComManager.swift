//
//  ComManager.swift
//  LifesMoments
//
//  Created by Gabriel on 3/5/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import Alamofire


class ComManager: NSObject {
    
    static let sharedInstance = ComManager()
    private override init() {
     
    }
    
    
    //TODO: make a genric
    
    
    /**
        this method returns a the new user hash or a -1 for user name is not a valiable
    */
    func checkUserAvailability(userName : String, password : String) -> String
    {
        //if json["message"] == not avaliable use name exists
        //else json["message"] is equle "use is avaliable" and json["hash"] has value
     
        
        //the server will create the user on the go
        
        
        //        //example on how to do it
        //        let parameters = [
        //            "name": "MIRCATsuperMAN"
        //        ]
        //
        //        //        Alamofire.request(.POST, "https://lifes-moments.herokuapp.com/api/bears", parameters: parameters)
        //
        //
        //        Alamofire.request(.POST, "https://lifes-moments.herokuapp.com/api/bears", parameters: ["name": "MOTI"])
        //            .response { request, response, data, error in
        //                print(request)
        //                print(response)
        //                print(data)
        //                print(error)
        //        }
        
        return "Stab"
    }
    


//    func publishStory(story : Story)
//    {
//        
//    }
    
    func downloadSharedStory()
    {
        
    }
    
//    func sendComment(newComment : Comment)
//    {
//        
//    }
    
    func getNewComments(storyId : Int) -> [Int : String]    //this will retun comments dict [comments id : message]
    {
        
//        Alamofire.request(.GET, "https://lifes-moments.herokuapp.com/api/", parameters: ["foo": "bar"])
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                
//                if let JSON = response.result.value {
//                    
//                    var tid: Int?
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
//                }
//        }
        
        return [1 : "Stab"]
    }

    
    func sendRating(userid : Int)   //this will act a flag //need to change the int to hash returned from the server
    {
        
    }
}
