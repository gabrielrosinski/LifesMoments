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

@objc public protocol VideoPlayerViewControllerDelegate {
    func videoFinishedPlaying()
    
}

class VideoPlayerViewController: UIViewController {

    public var delegate:   VideoPlayerViewControllerDelegate?
    
    //video
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var videoData:NSData?
    var dataPath:String?
    var videoISShowen:Bool = false
    
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
            let playerItem:AVPlayerItem = AVPlayerItem(URL: pathURL)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoPlayerViewController.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerView.currentItem)

            playerView = AVPlayer(URL: pathURL)
            playerView = AVPlayer(playerItem: playerItem)
//            playerViewController.player = playerView
//            playerViewController.showsPlaybackControls = false

            let playerLayer:AVPlayerLayer = AVPlayerLayer(player: playerView)
            playerLayer.frame = CGRectMake(3 , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)//self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            playerView.play()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {

//        if videoISShowen == false {
//            self.presentViewController(playerViewController, animated: false, completion: {
//                self.playerView.play()
//                self.videoISShowen = true
//            })
//            
//        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.playerView.replaceCurrentItemWithPlayerItem(nil)
    }


    func playerDidFinishPlaying(note: NSNotification) {
        //self.dismissViewControllerAnimated(false, completion: nil)
//        self.playerView.pause()
        delegate?.videoFinishedPlaying()
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
