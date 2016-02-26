//
//  ViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 2/25/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Realm


// Define your models like regular Swift classes
class Dog {
    dynamic var name = ""
    dynamic var age = 0
}


class Person {
    dynamic var name = ""
    dynamic var picture: NSData? = nil // optionals supported
    let dogs =  List<Dog>  //List<Dog>()
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
//        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }
        
        

        
        // Use them like regular Swift objects
        let myDog = Dog()
        myDog.name = "Rex"
        myDog.age = 1
        print("name of dog: \(myDog.name)")
        
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for all dogs less than 2 years old
        let puppies = realm.objects(Dog).filter("age < 2")
        puppies.count // => 0 because no dogs have been added to the Realm yet
        
        // Persist your data easily
        try! realm.write {
            realm.add(myDog)
        }
        
        // Queries are updated in real-time
        puppies.count // => 1
        
        // Query and update from any thread
        dispatch_async(dispatch_queue_create("background", nil)) {
            let realm = try! Realm()
            let theDog = realm.objects(Dog).filter("age == 1").first
            try! realm.write {
                theDog!.age = 3
            }
        }
        
        
        
        
    }


}

