//
//  User.swift
//  LifesMoments
//
//  Created by Gabriel on 3/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit


class User: NSObject {

    var _userName : String
    var _password : String
    
    init(userName: String, password: String){
        self._userName = userName
        self._password = password
    }
    
    
    func  objDescription(){
        print("user name: \(_userName)\n password: \(_password)")
    }
    
}
