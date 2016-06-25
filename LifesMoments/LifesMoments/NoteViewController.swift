//
//  NoteViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/2/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

@objc protocol NoteViewControllerDelegate {
    optional func getNoteToSave(note: NSData,currentMomentID:Int)
    optional func noteFinishedShowing()
}

class NoteViewController: UIViewController,UITextViewDelegate {

    var delegate: NoteViewControllerDelegate?
    var textSring: String = ""
    var editModeEnabled: Bool = true
    var currentMomentID = -1
    var displayTextTimer:NSTimer?
    let displayTextTime = 3.0
    

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveAndExitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTextView.delegate = self
        
        if !(textSring.isEmpty) {
            noteTextView.text = textSring
        }

        if !editModeEnabled {
            noteTextView.userInteractionEnabled = false
            saveAndExitButton.hidden = true
            
            displayTextTimer = NSTimer.scheduledTimerWithTimeInterval(displayTextTime, target:self,selector:#selector(NoteViewController.stopTextDisplayTimer), userInfo:nil, repeats:true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAndExitButtonPressed(sender: AnyObject) {
        
        if currentMomentID == -1 {
            UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .BeginFromCurrentState, animations: {
                self.saveAndExitButton.alpha = 0
            }) { (true) in
                
                self.saveAndExitButton.hidden = true
            }
        }

        let text = noteTextView.text
        if text != ""{
            let noteData = text.dataUsingEncoding(NSUTF8StringEncoding)
            if let delegate = self.delegate{
                postAlert("", message: "Note has been saved you may go back")
                
                delegate.getNoteToSave!(noteData!, currentMomentID: currentMomentID)
            }
        }else{
            postAlert("Error", message: "You haven't wrote anything")
        }

    }
    
    func stopTextDisplayTimer()
    {
        self.displayTextTimer?.invalidate()
        if ((self.delegate?.noteFinishedShowing?()) != nil){
            
        }else{
            print("no such selector")
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        noteTextView.endEditing(true)
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if noteTextView.text == "Write you note here"
        {
            noteTextView.text = ""
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
