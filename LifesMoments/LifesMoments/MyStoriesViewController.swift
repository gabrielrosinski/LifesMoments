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

    var collectionData: [String] = ["1", "2", "3", "4", "5"]
    
    var controllerMode: StoryMode?
    var storiesArray: [AnyObject]?

    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        
        var storiesMode =  self.controllerMode!
        
        if storiesMode == StoryMode.MyStories{
            //load my stories
        }else{
            // load shared stories
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return collectionData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        
        if (indexPath.row == 0) && (controllerMode == StoryMode.MyStories) {
            let cell: AddStoryCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier1,
                forIndexPath: indexPath) as! AddStoryCell
            
             return cell
        }else{
            let cell: StoryCellView = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier2,
                forIndexPath: indexPath) as! StoryCellView
            
            cell.cellLbl.text  = collectionData[indexPath.row]
            
         return cell
        }
            

        

        
//            // Configure the cell
//            let image = UIImage(named: carImages[indexPath.row])
//            cell.cellImage.image = image
        

        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func  collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell \(indexPath.row) Selcet")
    }

   
}
