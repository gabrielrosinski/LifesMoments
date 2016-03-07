//
//  User.swift
//  LifesMoments
//
//  Created by Gabriel on 3/7/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {

    dynamic var _userName : String = ""
    dynamic var _password : String = ""
    
    convenience init(userName: String, password: String){
        self.init()
        self._userName = userName
        self._password = password
    }
    
    
    func  objDescription(){
        print("user name: \(_userName)\n password: \(_password)")
    }
}
