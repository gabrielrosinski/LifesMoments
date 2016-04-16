//
//  StoryPlayerViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/16/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class StoryPlayerViewController: UIViewController {

    
    var playersVCArray = [AnyObject]()
    var currentStory:Story?
    var vcChangeTimer:NSTimer?
    
    

    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVCArray()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //vcChangeTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target:self,selector:#selector(StoryPlayerViewController.changeVC), userInfo:nil, repeats:true)
        
        changeVC()
    }
    
    
    //timer func will
    //-load the next moment and in the right vc and
    //-dissmis the previous vc
    //-push the loaded vc
    
    func changeVC() {
        
        
        //currentStory?._momentsList.valueForKey("_momentID")
        
        
        
        
        
        for moment in (self.currentStory?._momentsList)!{
            
            if moment._mediaType == 0 {
                
                if let ExistingImageData = moment._mediaData{
                    
                    let imageDisplayViewController =  self.playersVCArray[0] as! ImageDisplayViewController
                    
                    imageDisplayViewController.image = UIImage(data: ExistingImageData, scale: 1.0)
                    //self.navigationController?.pushViewController(imageDisplayViewController, animated: true)
                    
                    //                        self.presentViewController(imageDisplayViewController, animated: true, completion: {
                    //                            //nothing
                    //                        })
                    
                    self.containerView.addSubview(imageDisplayViewController.view)
                    imageDisplayViewController.didMoveToParentViewController(self)
                }
                
            }else if moment._mediaType == 1 {
                
            }else if moment._mediaType == 2 {
                
            }else if moment._mediaType == 3 {
                
            }
        }
        
        
//        let seconds = 2.0
//        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
//        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        
//        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
//            
//            // here code perfomed with delay
//
//            
//        })
        

        
    }
    
    func killVcChangeTimer(){
        self.vcChangeTimer!.invalidate()
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
    
    // create array with all vc's - done
    // create timer that will controller the change of vc's - done
    // turn on the timer
        //timer func will
        //-load the next moment and in the right vc and
        //-dissmis the previous vc
        //-push the loaded vc
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
