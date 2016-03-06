//
//  LoginViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 2/26/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController,UITextFieldDelegate  {

    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userName.delegate = self
        self.password.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        userName.resignFirstResponder()
        password.resignFirstResponder()
        return false
    }
    
    
    
    //this method will fetch the user object via user name from the database
    //if no such user exists the alertViewController will pop up and say no such user exists
    @IBAction func loginButtonPressed(sender: AnyObject) {
//        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
//        self.navigationController?.pushViewController(viewController, animated: true)
        
    }

}
