//
//  NoteViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 4/2/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate {
    func getNoteToSave(note: NSData,currentMomentID:Int)
}

class NoteViewController: UIViewController,UITextViewDelegate {

    var delegate: NoteViewControllerDelegate?
    var textSring: String = ""
    var editModeEnabled: Bool = true
//    var currentMomentID: Int?
    var currentMomentID = -1
    

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveAndExitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTextView.delegate = self
        
        if !(textSring.isEmpty) {
            noteTextView.text = textSring
        }

        
// TODO: - will use this on shared mode
        if !editModeEnabled {
            noteTextView.userInteractionEnabled = false
            saveAndExitButton.hidden = true
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
                
                delegate.getNoteToSave(noteData!, currentMomentID: currentMomentID)
                
//                if (currentMomentID == nil) {
//                    delegate.getNoteToSave(noteData!, currentMomentID: -1)
//                }else{
//                    delegate.getNoteToSave(noteData!, currentMomentID: currentMomentID!)
//                }
                
            }
        }else{
            postAlert("Error", message: "You haven't wrote anything")
        }

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        noteTextView.endEditing(true)
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
