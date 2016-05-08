//
//  AppDelegate.swift
//  LifesMoments
//
//  Created by Gabriel on 2/25/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Branch

protocol sharedStoryProtocol {
    func newSharedStoryRecived(storyId: String)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var delegate: sharedStoryProtocol?
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let branch: Branch = Branch.getInstance()
        branch.initSessionWithLaunchOptions(launchOptions, andRegisterDeepLinkHandler: { params, error in
            if (error == nil) {
                
                if let incomingDeepLink = params["$ios_url"]{
                    //print("params: \(params["$ios_url"]!)")
                    let fullString : String = incomingDeepLink as! String
                    let storyID:String = fullString.stringByReplacingOccurrencesOfString("lifemoments://", withString: "")
                    print(storyID)
                    
                    
                    
                    if (DBManager.sharedInstance.currentUser != nil) {
                        //go shared stories and start downloading
                        print()
                        self.delegate?.newSharedStoryRecived(storyID)
                    }else{
                        //go to login screen
                        //move to shared stories screen and start downloading the stroy

                    }
                }
            }else{
                print("there was an error \(error)")
            }
        })
        
        return true
    }

    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        
        Branch.getInstance().handleDeepLink(url);
        
//        let handled:Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
//        let parsedUrl:BFURL = BFURL.init(inboundURL: url, sourceApplication: sourceApplication)
//        
//        if (parsedUrl.appLinkData != nil) {
//            let targetUrl:NSURL = parsedUrl.targetURL
//            print("The target url is: \(targetUrl)")
//        }

        
        return true
    }
    
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        
        return Branch.getInstance().continueUserActivity(userActivity)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        DBManager.sharedInstance.saveCurrentUserTODB()
        DataManager.sharedInstance.saveDataToDB()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        DBManager.sharedInstance.saveCurrentUserTODB()
        DataManager.sharedInstance.saveDataToDB()
    }


}

