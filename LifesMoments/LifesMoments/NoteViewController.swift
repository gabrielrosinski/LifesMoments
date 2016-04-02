//
//  NoteViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/2/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var saveAndExitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAndExitButtonPressed(sender: AnyObject) {
        // save the note and return to previous controller
    }

}
