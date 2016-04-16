//
//  VideoPlayerViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/16/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController: UIViewController {

    
    //video
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var videoData:NSData?
    var dataPath:String?
    
    let saveFileName = "/video.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let createdVideoData = videoData {
            
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
            createdVideoData.writeToFile(dataPath!, atomically: false)
            
            let pathURL = NSURL(fileURLWithPath: dataPath!, isDirectory: false, relativeToURL: nil)
            playerView = AVPlayer(URL: pathURL)
            playerViewController.player = playerView
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {

        self.presentViewController(playerViewController, animated: false, completion: {
            self.playerView.play()
        })
        
    }

    
    
    /*
        
     
     let videoData = moment.element._mediaData
     let paths = NSSearchPathForDirectoriesInDomains(
     NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
     let documentsDirectory: AnyObject = paths[0]
     let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
     videoData?.writeToFile(dataPath, atomically: false)
     
     let pathURL = NSURL(fileURLWithPath: dataPath, isDirectory: false, relativeToURL: nil)
     playerView = AVPlayer(URL: pathURL)
     playerViewController.player = playerView
     self.presentViewController(playerViewController, animated: true, completion: {
     self.playerView.play()
     })
 
 
 
    */
    
    
    
    
}
