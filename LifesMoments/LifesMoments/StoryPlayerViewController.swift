//
//  StoryPlayerViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/16/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import AVFoundation
import Branch
import FBSDKShareKit

let VC_CHANGE_TIME = 2.0

class StoryPlayerViewController: UIViewController,VideoPlayerViewControllerDelegate,AudioPlayerViewControllerDelegate,ImageDisplayViewControllerDelegate,NoteViewControllerDelegate {

    
    var playersVCArray = [AnyObject]()
    var currentStory:Story?
    var vcChangeTimer:NSTimer?
    var currentIndex:Int = 0
    var lastVCUsed:AnyObject?
    var backGroundMusicplayer = AVAudioPlayer()
//    var playerItem:AVPlayerItem?
    
    @IBOutlet weak var theEndLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fbShareButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbShareButton.hidden = true
        playBackGroundMusic()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        changeVC()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //killVcChangeTimer()
        backGroundMusicplayer.stop()
    }
    
    @IBAction func fbShareClicked(sender: AnyObject) {
        
        publishToFB()
    }
    
    func publishToFB(){
        DBManager.sharedInstance.realm.beginWrite()
        currentStory?._sharedStory = true
        do {
            try DBManager.sharedInstance.realm.commitWrite()
        }catch{
            print("Error Happend")
        }
        
        
        //publish the story
        ComManager.sharedInstance.publishStory(currentStory!)
        
        DBManager.sharedInstance.realm.beginWrite()
        currentStory?._sharedStory = true
        do {
            try DBManager.sharedInstance.realm.commitWrite()
        }catch{
            print("setting shared to a story had an Error")
        }
        
        //save the change / update the story in the db
        DBManager.sharedInstance.saveStoryToDB(currentStory!, completion: {
        })
        
        DataManager.sharedInstance.fetchUpdatedStories()
        
        let currentStoryID:String = (self.currentStory?._storyId)!
        
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
        branchUniversalObject.title = "My Trip"
        branchUniversalObject.contentDescription = "Come see my new trip"
        branchUniversalObject.imageUrl = "http://res.cloudinary.com/daktpshwm/image/upload/\(currentStoryID).png"
        branchUniversalObject.addMetadataKey("property1", value: "blue")
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "sharing"
        linkProperties.channel = "facebook"
        
        linkProperties.addControlParam("$ios_url", withValue: "lifemoments://\(currentStoryID)")
        
        branchUniversalObject.getShortUrlWithLinkProperties(linkProperties,  andCallback: { (url: String?, error: NSError?) -> Void in
            if error == nil {
                print("got my Branch link to share: %@", url)
                
                
                let content:FBSDKShareLinkContent = FBSDKShareLinkContent()
                content.contentURL = NSURL(string: url!)
                
                FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
            }
        })
    }

    
    func playBackGroundMusic()
    {
//        var backTrackPath:String = NSBundle.mainBundle().pathForResource("backTrack", ofType: "mp3")!
        var backTrackPath:String = DataManager.sharedInstance.whichTrackToPlay()
        let url:NSURL = NSURL(fileURLWithPath: backTrackPath)
        do{
            self.backGroundMusicplayer = try AVAudioPlayer(contentsOfURL: url)
            self.backGroundMusicplayer.prepareToPlay()
            self.backGroundMusicplayer.volume = 1.0
            self.backGroundMusicplayer.play()
        }catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    
    func volumeFadeOut() {
        if (self.backGroundMusicplayer.volume > 0.2) {
            self.backGroundMusicplayer.volume = self.backGroundMusicplayer.volume - 0.1;
            self.performSelector(#selector(volumeFadeOut), withObject: nil, afterDelay: 0.1)
        }
    }
    
    func volumeFadeIn() {
        if (self.backGroundMusicplayer.volume < 1.0) {
            self.backGroundMusicplayer.volume = self.backGroundMusicplayer.volume + 0.1;
            self.performSelector(#selector(volumeFadeIn), withObject: nil, afterDelay: 0.1)
        }
    }
    
    
//    -(void)doVolumeFade
//    {
//    if (self.player.volume > 0.1) {
//    self.player.volume = self.player.volume - 0.1;
//    [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.1];
//    } else {
//    // Stop and get the sound ready for playing again
//    [self.player stop];
//    self.player.currentTime = 0;
//    [self.player prepareToPlay];
//    self.player.volume = 1.0;
//    }
//    }
    
    
    func changeVC() {

        if currentIndex < currentStory?._momentsList.count {

            if let moment = currentStory?._momentsList[currentIndex] {
                
                removeVcFromContainer()
                
                if moment._mediaType == 0 { //image
                    
//                    self.backGroundMusicplayer.volume = 1.0
                    
                    
                    if self.backGroundMusicplayer.volume < 1.0 {
                        volumeFadeIn()
                    }
                    
//                    if let ExistingImageData = moment._mediaData{
//                        
//                        let imageDisplayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageDisplayViewController") as! ImageDisplayViewController
//                        imageDisplayViewController.image = UIImage(data: ExistingImageData, scale: 1.0)
//                        imageDisplayViewController.delegate = self
//                        
//                        lastVCUsed = imageDisplayViewController
//                        
//                        self.containerView.addSubview(imageDisplayViewController.view)
//                        imageDisplayViewController.didMoveToParentViewController(self)
//                    }
                    
                    
                    let imageDisplayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageDisplayViewController") as! ImageDisplayViewController
                    imageDisplayViewController.image = UIImage(data: moment._mediaData, scale: 1.0)
                    imageDisplayViewController.delegate = self
                    
                    lastVCUsed = imageDisplayViewController
                    
                    self.containerView.addSubview(imageDisplayViewController.view)
                    imageDisplayViewController.didMoveToParentViewController(self)
                    
                    
                }else if moment._mediaType == 1 { //video
                    
//                    self.backGroundMusicplayer.volume = 0.2
                    if self.backGroundMusicplayer.volume == 1.0 {
                        volumeFadeOut()
                    }
                    
                    removeVcFromContainer()
                    
                    let videoPlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VideoPlayerViewController") as! VideoPlayerViewController
                    
                    videoPlayerViewController.videoData = moment._mediaData
                    videoPlayerViewController.delegate = self
                    
                    lastVCUsed = videoPlayerViewController
                    
                    self.containerView.addSubview(videoPlayerViewController.view)
                    videoPlayerViewController.didMoveToParentViewController(self)
                    
                }else if moment._mediaType == 2 { //audio
                    
//                    self.backGroundMusicplayer.volume = 0.2
                    if self.backGroundMusicplayer.volume == 1.0 {
                        volumeFadeOut()
                    }
                    
                    removeVcFromContainer()
                    
                    let audioPlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AudioPlayerViewController") as!
                    AudioPlayerViewController
                    
                    audioPlayerViewController.audioData = moment._mediaData
                    audioPlayerViewController.delegate = self
                    
                    lastVCUsed = audioPlayerViewController
                    
                    self.containerView.addSubview(audioPlayerViewController.view)
                    audioPlayerViewController.didMoveToParentViewController(self)
                    
                }else if moment._mediaType == 3 { //text

                    if self.backGroundMusicplayer.volume < 1.0 {
                        volumeFadeIn()
                    }
                    
                    removeVcFromContainer()
                    
                    let noteViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NoteViewController") as! NoteViewController
                    let text = String(data: moment._mediaData, encoding: NSUTF8StringEncoding)
                    noteViewController.textSring = text!
                    noteViewController.editModeEnabled = false
                    noteViewController.delegate = self
                    
                    lastVCUsed = noteViewController
                    
                    self.containerView.addSubview(noteViewController.view)
                    noteViewController.didMoveToParentViewController(self)
                }
            }
        }
        
        if currentIndex <= (currentStory?._momentsList.endIndex)! - 1{
            currentIndex += 1
        }else{
            print("moments list is finnished the last index was \(currentIndex)")
            removeVcFromContainer()
            currentIndex = -1
            self.theEndLabel.hidden = false
            self.fbShareButton.hidden = false
            self.backGroundMusicplayer.stop()
        }
    }
    
    func killVcChangeTimer(){
        self.vcChangeTimer!.invalidate()
        currentIndex = 0   
    }
    
    func removeVcFromContainer()
    {

        if (lastVCUsed != nil){
            // call before removing child view controller's view from hierarchy
            lastVCUsed!.willMoveToParentViewController(nil)
            
            lastVCUsed!.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            lastVCUsed!.removeFromParentViewController()
        }
    }
  
    //MARK: VideoPlayerViewController Delegate Methods
    func videoFinishedPlaying() {
        print("Hooray video stoped")
        removeVcFromContainer()
        if currentIndex != -1 {
            changeVC()
        }
    }
    
    func audioFinishedPlaying() {
        print("Hooray audio stoped")
        removeVcFromContainer()
        if currentIndex != -1 {
            changeVC()
        }
    }
    
    func imageFinishedShowing() {
        print("Hooray image finished showing")
        removeVcFromContainer()
        if currentIndex != -1 {
            changeVC()
        }
    }
    
    func noteFinishedShowing() {
        print("Hooray note finished showing")
        removeVcFromContainer()
        if currentIndex != -1 {
            changeVC()
        }
    }

 
    func setVCArray () {
        
        //stills,video,audio,text
        
        let imageDisplayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageDisplayViewController") as! ImageDisplayViewController
        
        let videoPlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VideoPlayerViewController") as! VideoPlayerViewController
        
        let audioPlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AudioPlayerViewController") as! AudioPlayerViewController
        
        let noteViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NoteViewController") as! NoteViewController
        
        self.playersVCArray.append(imageDisplayViewController)
        self.playersVCArray.append(videoPlayerViewController)
        self.playersVCArray.append(audioPlayerViewController)
        self.playersVCArray.append(noteViewController)
        
    }
    
}








//    self.view.backgroundColor = UIColor.randomColor()

extension UIColor {
    static func randomColor() -> UIColor {
        let r = CGFloat.random()
        let g = CGFloat.random()
        let b = CGFloat.random()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
