//
//  NoteViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/2/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate {
    func getNoteToSave(note: NSData)
}

class NoteViewController: UIViewController {

    var delegate: NoteViewControllerDelegate?
    
    @IBOutlet weak var noteTextView: UITextView!
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
        
        
        let text = noteTextView.text
        if text != ""{
            let noteData = text.dataUsingEncoding(NSUTF8StringEncoding)
            if let delegate = self.delegate{
                delegate.getNoteToSave(noteData!)
            }
        }else{
            postAlert("Error", message: "You haven't wrote anything")
        }

    }
    
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
