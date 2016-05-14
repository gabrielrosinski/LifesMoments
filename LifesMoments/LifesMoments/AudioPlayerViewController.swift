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
    @IBOutlet weak var audioAnimationView: UIView!
    
    public var delegate: AudioPlayerViewControllerDelegate?
    
    var audioData:NSData?
    var audioPlayer:ASAudioPlayer? = nil
    let saveAudioFile = "/audio.mp3"

    var playerView = AVPlayer()
    var playerItem:AVPlayerItem?
    var audioAnimationPlayerView = AVPlayer()
    var animPlayerItem:AVPlayerItem?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(saveAudioFile)
        audioData?.writeToFile(dataPath, atomically: false)
        
        let pathURL = NSURL(fileURLWithPath: dataPath, isDirectory: false, relativeToURL: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioPlayerViewController.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerView.currentItem)
        
        
        playerItem = AVPlayerItem(URL: pathURL)
        playerView = AVPlayer(playerItem: playerItem!)
        playerView.volume = 100
        
        do{
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord,
                                    withOptions:AVAudioSessionCategoryOptions.DefaultToSpeaker)
        }
        
        let playerLayer:AVPlayerLayer = AVPlayerLayer(player: playerView)
        playerLayer.frame = CGRectMake(3 , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)//self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        playerView.play()
        
        
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("audioAnim", withExtension: "mp4")!
        animPlayerItem = AVPlayerItem(URL: videoURL)
        audioAnimationPlayerView = AVPlayer(playerItem: animPlayerItem!)
        let animationPlayerLayer = AVPlayerLayer(player: audioAnimationPlayerView)
        animationPlayerLayer.frame = self.audioAnimationView!.bounds
        animationPlayerLayer.frame.origin.x = 30
        self.audioAnimationView!.layer.addSublayer(animationPlayerLayer)
        audioAnimationPlayerView.play()
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        playerView.pause()
        playerView.replaceCurrentItemWithPlayerItem(nil)
        
        audioAnimationPlayerView.pause()
        audioAnimationPlayerView.replaceCurrentItemWithPlayerItem(nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func playerDidFinishPlaying(note: NSNotification) {
        
        if let playerObj = note.object as? AVPlayerItem{
            if playerObj == self.playerItem{
                print(playerObj)
                self.audioAnimationPlayerView.pause()
                self.delegate?.audioFinishedPlaying()
            }else if playerObj == self.animPlayerItem{
                print(playerObj)
                //play the anime on the loop
                self.audioAnimationPlayerView.seekToTime(kCMTimeZero)
                self.audioAnimationPlayerView.play()
            }
        }
    }
    
}
