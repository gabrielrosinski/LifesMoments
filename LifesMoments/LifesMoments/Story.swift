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
//import ObjectMapper



class Story: Object {

    dynamic var  _storyId: String?                   //will be deafulty 0 must be changed on every ob creatiob
    dynamic var  _userId: String?
    dynamic var  _base64PicData: String = ""
    dynamic var  _dataOfCreation: String?
    dynamic var  _userIdOfTheDownloader: String = ""
    dynamic var  _startLatitude: Double = 0.0
    dynamic var  _startLongitude: Double = 0.0
    dynamic var  _endLatitude: Double = 0.0
    dynamic var  _endLongitude: Double = 0.0
    dynamic var  _sharedStory: Bool = false
    dynamic var  _curentMomentID: Int = 0
    var _momentsList = List<Moment>()
    var _style: StoryStyle? = StoryStyle()
    

    override static func primaryKey() -> String? {
        return "_storyId"
    }
    
    convenience init(storyJson:[String:AnyObject]) {
     self.init()
        
//        print(storyJson)
        self._storyId = storyJson["storyId"] as? String
        self._userId = storyJson["userId"] as? String
        self._userId = storyJson["dataOfCreation"] as? String
        self._userId = storyJson["base64PicData"] as? String
        self._userIdOfTheDownloader = DBManager.sharedInstance.currentUser!._userName!//storyJson["_userIdOfTheDownloader"] as? String
        self._startLongitude = Double((storyJson["startLongitude"] as? String)!)!
        self._endLongitude = Double((storyJson["endLongitude"] as? String)!)!
        self._startLatitude = Double((storyJson["startLatitude"] as? String)!)!
        self._endLatitude = Double((storyJson["endLatitude"] as? String)!)!
        self._sharedStory = ((storyJson["sharedStory"] as? String)?.toBool())!
        
        let momentsArray:Array = (storyJson["momentsArray"] as! NSArray) as Array
        
        for momentJson in momentsArray {
//            print(momentJson)
            let jsonDict:[String:AnyObject] = momentJson as! [String : AnyObject]
            let newMoment = Moment(momentJsonStr: jsonDict)
            self._momentsList.append(newMoment)

//in case this will be needed
//            DBManager.sharedInstance.realm.beginWrite()
//            
//            do {
//                try DBManager.sharedInstance.realm.commitWrite()
//            }catch{
//                print("Error Happend")
//            }
        }
    }


    func getStoryDict() -> [String : AnyObject]{
        
        var momentsArray = [AnyObject]()
        
        for moment in self._momentsList {
            momentsArray.append(moment.getMomentDict())
        }
        
        let storyDict:[String:AnyObject] = ["storyId":self._storyId!,
                                             "userId":self._userId!,
                                             "dataOfCreation":self._dataOfCreation!,
                                             "base64PicData":self._base64PicData,
                                             "_userIdOfTheDownloader":self._userIdOfTheDownloader,
                                             "startLatitude":self._startLatitude,
                                             "startLongitude":self._startLongitude,
                                             "endLatitude":self._endLatitude,
                                             "endLongitude":self._endLongitude,
                                             "sharedStory":self._sharedStory,
                                             "currentMomentID":self._curentMomentID,
                                             "momentsArray":momentsArray]
        return storyDict
    }
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

