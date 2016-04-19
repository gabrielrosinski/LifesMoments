//
//  AudioPlayerViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/10/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import ASAudioPlayer
import AVFoundation


@objc public protocol AudioPlayerViewControllerDelegate{
    func audioFinishedPlaying()
    
}


class AudioPlayerViewController: UIViewController {
    
    @IBOutlet weak var audioPlayerContainer: UIView!
    var audioData:NSData?
    var audioPlayer:ASAudioPlayer? = nil
    let saveAudioFile = "/audio.mp3"

    public var delegate: AudioPlayerViewControllerDelegate?
    
    var playerView = AVPlayer()
    var playerItem:AVPlayerItem?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let audioPlayer = ASAudioPlayer(frame: CGRect(x: 3, y: (self.view.frame.height / 2.0 - 100), width: self.view.frame.width, height: 100))
        
       
        
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(saveAudioFile)
        audioData?.writeToFile(dataPath, atomically: false)
        
        let pathURL = NSURL(fileURLWithPath: dataPath, isDirectory: false, relativeToURL: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoPlayerViewController.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerView.currentItem)
        
        playerItem = AVPlayerItem(URL: pathURL)
        playerView = AVPlayer(playerItem: playerItem!)


        let playerLayer:AVPlayerLayer = AVPlayerLayer(player: playerView)
        playerLayer.frame = CGRectMake(3 , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)//self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        playerView.play()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        playerView.pause()
        playerView.replaceCurrentItemWithPlayerItem(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func playerDidFinishPlaying(note: NSNotification) {
        delegate?.audioFinishedPlaying()
    }
    
}
