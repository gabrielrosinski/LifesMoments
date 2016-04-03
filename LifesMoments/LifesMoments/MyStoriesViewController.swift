//
//  MyStoriesViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 3/22/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit


private let reuseIdentifier1 = "AddStoryCell"
private let reuseIdentifier2 = "StoryCell"


enum StoryMode: Int {
    case MyStories = 0
    case SharedStories = 1
}

class MyStoriesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var collectionData: [String] = []//["1", "2", "3", "4", "5"]
    var controllerMode: StoryMode?

    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        
        let storiesMode =  self.controllerMode!
        
//        if storiesMode == StoryMode.MyStories{
//            //TODO: load my stories from DB
//            let storiesList = DBManager.sharedInstance.myStories
//            for story in storiesList {
//               storiesArray.append(story)
//            }
//        }else{
//            //TODO: load shared stories from DB
//            let sharedStoriesList = DBManager.sharedInstance.sharedStories
//            for sharedStory in sharedStoriesList {
//                sharedStoriesArray.append(sharedStory)
//            }
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        storyCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//                cell.cellLbl.text  = collectionData[indexPath.row - 1]
//            }else{
//                cell.cellLbl.text  = collectionData[indexPath.row]
//            }
            
            cell.backgroundColor = UIColor.redColor()
            
            
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
        
        //TODO: look into how and when the stories/shared are loaded
        
    }
    
    func createNewStory() -> Story {
        let newStory = Story()
        newStory._storyId = getLastStoryIDForUserID() + 1
        let user = DBManager.sharedInstance.currentUser
        
        DBManager.sharedInstance.realm.beginWrite()
        user?._curentStoryID = newStory._storyId
        do {
           try DBManager.sharedInstance.realm.commitWrite()
        }catch{
            print("Error Happend")
        }

        newStory._userId = user?._userName
        return newStory
    }
   
    func getLastStoryIDForUserID() -> Int {
        
        let user = DBManager.sharedInstance.currentUser
        
        return (user?._curentStoryID)!
    }
    

    
}
