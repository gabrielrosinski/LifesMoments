//
//  PagerViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 3/19/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import PagingMenuController

class PagerViewController: UIViewController,PagingMenuControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "PAGE MENU"
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]

        
        let myStory = self.storyboard?.instantiateViewControllerWithIdentifier("MyStoriesViewController") as! MyStoriesViewController
        let sharedStory = self.storyboard?.instantiateViewControllerWithIdentifier("MyStoriesViewController") as! MyStoriesViewController
        myStory.title = "My Stories"
        sharedStory.title = "Shared Stories"
        myStory.controllerMode = StoryMode.MyStories
        sharedStory.controllerMode = StoryMode.SharedStories
        
        
        
        sharedStory.view.backgroundColor = UIColor.redColor()
        
        let viewControllers = [myStory, sharedStory]
        
        let options = PagingMenuOptions()
        options.menuHeight = 50
        options.menuItemMargin = 5
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        options.selectedBackgroundColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)//UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        options.menuItemMode = .Underline(height: 3, color: UIColor.orangeColor(), horizontalPadding: 0, verticalPadding: 0)
        options.selectedTextColor = UIColor.whiteColor()
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


/*
override func viewDidLoad() {
super.viewDidLoad()



self.title = "PAGE MENU"
self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
self.navigationController?.navigationBar.shadowImage = UIImage()
self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]



let vc1 = self.storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
let vc2 = self.storyboard?.instantiateViewControllerWithIdentifier("ThirdViewController") as! ThirdViewController
vc1.title = "Story"
vc2.title = "My Stories"

let viewControllers = [vc1, vc2]

let options = PagingMenuOptions()
options.menuHeight = 50
options.menuItemMargin = 5
options.menuDisplayMode = .SegmentedControl
options.backgroundColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
options.selectedBackgroundColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)//UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
options.menuItemMode = .Underline(height: 3, color: UIColor.orangeColor(), horizontalPadding: 0, verticalPadding: 0)
options.selectedTextColor = UIColor.whiteColor()

let pagingMenuController = self.childViewControllers.first as! PagingMenuController
pagingMenuController.delegate = self
pagingMenuController.setup(viewControllers: viewControllers, options: options)
}


*/