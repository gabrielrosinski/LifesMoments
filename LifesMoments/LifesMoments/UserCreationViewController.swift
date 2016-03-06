//
//  UserCreationViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 3/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit





class UserCreationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBAction func signupButtonClicked(sender: AnyObject) {
        
        
        
        if(self.passwordTextField.text == "" || userNameTextField.text == "" || confirmPasswordTextField.text == ""){
            showAlertController( "Mistake", _messege: "Some field is left empty")
            return
        }
        
        
        if((passwordTextField.text == confirmPasswordTextField.text) ){

            ComManager.sharedInstance.createNewUser(self.userNameTextField.text!, password: self.passwordTextField.text!, completion: { (response) -> Void in
                
                if(response == "User Exist!"){
                    
                    print("")
                    self.showAlertController(response, _messege: "Choosen user name is takes please choose another.")
                    
                }else if (response == "User Created!"){
                    
                    let newUser = User(userName: self.userNameTextField.text!, password: self.passwordTextField.text!)
                    print(newUser)
                    
                }
                
            })
        }
    }
    
    
    func showAlertController (_title: String, _messege :String){
        
        let alertController = UIAlertController(title:_title, message:_messege, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            //print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        return false
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
