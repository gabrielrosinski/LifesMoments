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
    var storiesArray: [Story] = [Story]()
    var sharedStoriesArray: [Story] = [Story]()

    

    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        
        var storiesMode =  self.controllerMode!
        
        if storiesMode == StoryMode.MyStories{
            //TODO: load my stories from DB
        }else{
            //TODO: load shared stories from DB
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        if controllerMode == StoryMode.MyStories{
            return collectionData.count + 1
        }else{
            return collectionData.count
        }
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        if (indexPath.row == 0) && (controllerMode == StoryMode.MyStories) {
            let cell: AddStoryCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier1,forIndexPath: indexPath) as! AddStoryCell
            return cell
            
        }else{
            
            let cell: StoryCellView = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier2,forIndexPath: indexPath) as! StoryCellView
            
            if controllerMode == StoryMode.MyStories{
                cell.cellLbl.text  = collectionData[indexPath.row - 1]
            }else{
                cell.cellLbl.text  = collectionData[indexPath.row]
            }
            
            
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
            storyVc.currentStory = Story()
            self.navigationController?.pushViewController(storyVc, animated: true)
            
        }else if indexPath.row != 0 && controllerMode == StoryMode.MyStories{
            let storyVc = self.storyboard?.instantiateViewControllerWithIdentifier("StoryViewController") as! StoryViewController
            storyVc.storyControllerMode = CurrentStoryMode.Editor
            storyVc.currentStory = sharedStoriesArray[indexPath.row]
            self.navigationController?.pushViewController(storyVc, animated: true)
            
        }else if controllerMode == StoryMode.SharedStories {
         
            let storyVc = self.storyboard?.instantiateViewControllerWithIdentifier("StoryViewController") as! StoryViewController
            storyVc.storyControllerMode = CurrentStoryMode.Viewer
            storyVc.currentStory = sharedStoriesArray[indexPath.row]
            self.navigationController?.pushViewController(storyVc, animated: true)
        }
        
        //TODO: look into how and when the stories/shared are loaded
        
    }
   
}
