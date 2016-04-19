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
        
        imageView.image = image

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        displayImageTimer = NSTimer.scheduledTimerWithTimeInterval(imageDisplayTime, target:self,selector:#selector(ImageDisplayViewController.stopImageTimer), userInfo:nil, repeats:true)
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
