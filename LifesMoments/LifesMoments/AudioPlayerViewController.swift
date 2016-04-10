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

class AudioPlayerViewController: UIViewController {
    
    @IBOutlet weak var audioPlayerContainer: UIView!
    var audioData:NSData?
    let audioPlayer:ASAudioPlayer? = nil
    let saveAudioFile = "/audio.mp3"

    override func viewDidLoad() {
        super.viewDidLoad()

        let audioPlayer = ASAudioPlayer(frame: CGRect(x: 0, y: (self.view.frame.height / 2.0 - 100), width: self.view.frame.width, height: 100))
        
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(saveAudioFile)
        audioData?.writeToFile(dataPath, atomically: false)
        
        let pathURL = NSURL(fileURLWithPath: dataPath, isDirectory: false, relativeToURL: nil)
        
        audioPlayer.setUrl(pathURL)
        self.view.addSubview(audioPlayer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        audioPlayer.audioPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
