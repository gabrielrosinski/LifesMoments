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
    
    
    
//    let navController:UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userName.delegate = self
        self.password.delegate = self

        

        //print(user)

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
        
        if let user  = DBManager.sharedInstance.loadUserFromDB(userName.text!){
            if((user._userName == self.userName.text) && (user._password == self.password.text)){
                //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let pagerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PagerViewController") as! PagerViewController
                let navController = UINavigationController(rootViewController: pagerViewController)
                self.presentViewController(navController, animated:true, completion: nil)
                
                
//                self.navigationController?.pushViewController(viewController, animated: true)

            }
        }else{
            let alertController = UIAlertController(title: "Error", message: "Wrong user name or password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }        
    }
    
    
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        
        let userCreationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserCreationViewController") as! UserCreationViewController
        let navController = UINavigationController(rootViewController: userCreationViewController)

        userCreationViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: Selector("popToRoot"))
        
        self.presentViewController(navController, animated:true, completion: nil)
    }
    
    
    func popToRoot(){//(sender:UIBarButtonItem){
//        self.navigationController!.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func authoriseUser(user:User) -> Bool
    {
        
        return true
    }

}
