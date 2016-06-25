//
//  SettingsViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 6/25/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var bgMusicPicker: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgMusicPicker.selectedSegmentIndex = DataManager.sharedInstance.backgroundTrack
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseBGTrackPressed(sender: AnyObject) {
        
        DataManager.sharedInstance.setBackGroundTrack(bgMusicPicker.selectedSegmentIndex)
        
    }
}
