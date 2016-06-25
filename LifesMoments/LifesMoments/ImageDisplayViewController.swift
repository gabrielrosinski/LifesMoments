//
//  ImageDisplayViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/3/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

public protocol ImageDisplayViewControllerDelegate {
    func imageFinishedShowing()
}

class ImageDisplayViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image:UIImage?
    var displayImageTimer:NSTimer?
    let imageDisplayTime = 3.0
    
    public var delegate: ImageDisplayViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.alpha = 0.0
        imageView.image = image

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        displayImageTimer = NSTimer.scheduledTimerWithTimeInterval(imageDisplayTime, target:self,selector:#selector(ImageDisplayViewController.stopImageTimer), userInfo:nil, repeats:true)

        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.imageView.alpha = 1.0
            
            }, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //there might be a problem here it might be fading out to quickly
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.imageView.alpha = 0.0
            
            }, completion: nil)
    }

    func stopImageTimer() {
        self.displayImageTimer?.invalidate()
        self.delegate?.imageFinishedShowing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
