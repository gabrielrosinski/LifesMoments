//
//  MyStoriesViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 3/22/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import Branch


private let reuseIdentifier1 = "AddStoryCell"
private let reuseIdentifier2 = "StoryCell"


enum StoryMode: Int {
    case MyStories = 0
    case SharedStories = 1
}

class MyStoriesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,sharedStoryProtocol,DBMangerProtocol,UIGestureRecognizerDelegate {

//    var collectionData: [String] = ["1", "2", "3", "4", "5"]
    var controllerMode: StoryMode?

    
    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.delegate = self
        
        let longPress : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MyStoriesViewController.longGesturePressed(_:)))
        longPress.minimumPressDuration = 1.0
        longPress.delegate = self
        longPress.delaysTouchesBegan = true
        self.storyCollectionView?.addGestureRecognizer(longPress)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 10, right: 30)
        layout.itemSize = CGSize(width: 140, height: 150)
        storyCollectionView.collectionViewLayout = layout

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        storyCollectionView.reloadData()
    }
    
    func longGesturePressed(gesture:UILongPressGestureRecognizer)
    {
        if (gesture.state != UIGestureRecognizerState.Ended){
            return
        }
        
        let p = gesture.locationInView(self.storyCollectionView)
        
        if let indexPath : NSIndexPath = (self.storyCollectionView?.indexPathForItemAtPoint(p))!{

            let alertController = UIAlertController(title: "Delete chosen Story", message: "Do you really want to delete this story ?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ... do nothing
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.deleteStroyFrom(indexPath.row)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        
    }
    
    
    func deleteStroyFrom(storyIndex:Int){
        if storyIndex != 0 && controllerMode == StoryMode.MyStories{

            let storyToDelete:Story = DataManager.sharedInstance.storiesArray[storyIndex - 1]
           deleteStoryfromCollection(storyToDelete)

        }else if controllerMode == StoryMode.SharedStories {
            
            let storyToDelete:Story = DataManager.sharedInstance.sharedStoriesArray[storyIndex]
            //this meens this story was created by this user
            if storyToDelete._userIdOfTheDownloader == ""{
                ComManager.sharedInstance.deleteStory(storyToDelete._storyId!)
                deleteStoryfromCollection(storyToDelete)
            }else{
                deleteStoryfromCollection(storyToDelete)
            }
        }
    }
    
    func deleteStoryfromCollection(story:Story){
        DBManager.sharedInstance.deleteStory(story)
        DataManager.sharedInstance.fetchUpdatedStories()
        storyCollectionView.reloadData()
    }
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        if controllerMode == StoryMode.MyStories{
            return DataManager.sharedInstance.storiesArray.count + 1
        }else{
            return DataManager.sharedInstance.sharedStoriesArray.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if (indexPath.row == 0) && (controllerMode == StoryMode.MyStories) {
            let cell: AddStoryCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier1,forIndexPath: indexPath) as! AddStoryCell
            return cell
            
        }else{
            
            let cell: StoryCellView = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier2,forIndexPath: indexPath) as! StoryCellView
            
//            if controllerMode == StoryMode.MyStories{
//                cell.cellImage = nil
//                cell.backgroundColor = UIColor.redColor()
//                cell.cellLbl.text = collectionData[indexPath.row]
//            }

            return cell
        }
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func  collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {


        if controllerMode == StoryMode.MyStories && indexPath.row == 0{
            
            let storyVc = self.storyboard?.instantiateViewControllerWithIdentifier("StoryViewController") as! StoryViewController
            storyVc.storyControllerMode = CurrentStoryMode.Editor
            storyVc.currentStory = createNewStory()
            DataManager.sharedInstance.storiesArray.append(storyVc.currentStory!)
            self.navigationController?.pushViewController(storyVc, animated: true)
            
        }else if indexPath.row != 0 && controllerMode == StoryMode.MyStories{
            
            let storyVc = self.storyboard?.instantiateViewControllerWithIdentifier("StoryViewController") as! StoryViewController
            storyVc.storyControllerMode = CurrentStoryMode.Editor
            storyVc.currentStory = DataManager.sharedInstance.storiesArray[indexPath.row - 1]
            self.navigationController?.pushViewController(storyVc, animated: true)
                
        }else if controllerMode == StoryMode.SharedStories {
         
            let storyVc = self.storyboard?.instantiateViewControllerWithIdentifier("StoryViewController") as! StoryViewController
            storyVc.storyControllerMode = CurrentStoryMode.Viewer
            storyVc.currentStory = DataManager.sharedInstance.sharedStoriesArray[indexPath.row]
            self.navigationController?.pushViewController(storyVc, animated: true)
        }
    }
    
    func createNewStory() -> Story {
        let newStory = Story()
        let newStoryIDStr:String = String(getLastStoryIDForUserID() + 1)
        let userIDStr:String = String(UTF8String: (DBManager.sharedInstance.currentUser?._userName)!)!
        newStory._storyId = "\(userIDStr)-\(newStoryIDStr)"
        //"\(DBManager.sharedInstance.currentUser?._userName)-\(getLastStoryIDForUserID() + 1)"
        print(newStory._storyId)
        let user = DBManager.sharedInstance.currentUser
        
        DBManager.sharedInstance.realm.beginWrite()
        user?._curentStoryCount = getLastStoryIDForUserID() + 1
        do {
           try DBManager.sharedInstance.realm.commitWrite()
        }catch{
            print("Saveing a story had an Error")
        }

        newStory._userId = user?._userName
        return newStory
    }
   
    func getLastStoryIDForUserID() -> Int {
        
        let user = DBManager.sharedInstance.currentUser
        
        return (user?._curentStoryCount)!
    }
    
    func newSharedStoryRecived(storyId: String)
    {
        var storyExists:Bool = false
        
        for story in DBManager.sharedInstance.sharedStories {
            if story._storyId == storyId{
                storyExists = true
                break
            }
        }
        
        if storyExists == false {
            DBManager.sharedInstance.delegate = self
            //downloading the new
            ComManager.sharedInstance.downloadSharedStory(storyId)
        }else{
            print("Story exists no need to download")
            //TODO: show alert view to the user
        }
    }
    
    func newSharedStorySavedInDB() {
        if controllerMode == StoryMode.SharedStories {
            self.storyCollectionView.reloadData()
        }
        
        
//        dispatch_async(dispatch_get_main_queue()) {
//            self.storyCollectionView.reloadData()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
