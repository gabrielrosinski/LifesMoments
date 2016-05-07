//
//  StoryViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 3/23/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import LiquidFloatingActionButton
import MobileCoreServices
import AVKit
import AVFoundation
import ASAudioPlayer
import FBSDKShareKit
import Branch



enum CurrentStoryMode: Int {
    case Editor = 0
    case Viewer = 1
}

class StoryViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,LiquidFloatingActionButtonDataSource,LiquidFloatingActionButtonDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,NoteViewControllerDelegate,VoiceNoteViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    //video
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    //audio
    var audioRecorder:AVAudioRecorder!
    
    //utils
    var currentStory: Story?
    var storyControllerMode: CurrentStoryMode?
    
    //location
    let locationManager: CLLocationManager = CLLocationManager()
    var momentPoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var currentLocation: CLLocationCoordinate2D?
    
    //floating buttons
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    var storyPlayerButton:UIButton?
    var bottomRightButton:LiquidFloatingActionButton?
    
    
    var _locations: [MomentLocation] = []/*[MomentLocation(latitude: -23.595571, longitude: -46.684408), MomentLocation(latitude: -23.597886, longitude: -46.673950),
        MomentLocation(latitude: -23.597886, longitude: -46.673950), MomentLocation(latitude: -23.597591, longitude: -46.666805),
        MomentLocation(latitude: -23.597591, longitude: -46.666805), MomentLocation(latitude: -23.604061, longitude: -46.662728)]*/

    
    //video example 2
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/video.mp4"
    let saveAudioFile = "/audio.mp3"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.addAnnotations(_locations)
        zoomToRegion()
        renderPolyLine()

        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if ((currentStory?._startLatitude) == 0){
            locationManager.startUpdatingLocation()
        }

        
        currentStory?._momentsList
        
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            return LiquidFloatingCell(icon: UIImage(named: iconName)!)
        }
        
        cells.append(cellFactory("lifemoments-video"))
        cells.append(cellFactory("lifemoments-photo"))
        cells.append(cellFactory("lifemoments-voice"))
        cells.append(cellFactory("lifemoments-text"))
        cells.append(cellFactory("lifemoments-facebook-orange"))
        
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 82, width: 56, height: 56)
        bottomRightButton = createButton(floatingFrame, .Up)
        
        storyPlayerButton = createStoryPlayerButton()
        
        self.view.addSubview(storyPlayerButton!)
        self.mapView.addSubview(bottomRightButton!)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        _locations = getMapAnnotations()
        mapView.removeAnnotations(_locations)
        mapView.addAnnotations(_locations)
        renderPolyLine()
    }
    
    override func viewWillDisappear(animated: Bool) {
        DataManager.sharedInstance.updateStory(currentStory!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - StoryPlaye Button
    func createStoryPlayerButton()-> UIButton {
        let button = UIButton(type:UIButtonType.System)   //.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(self.view.frame.width - 56 - 16,
                                  self.view.frame.height - 56 - 142,
                                  56,
                                  56)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Button", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(StoryViewController.playStoryClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }

    func playStoryClicked()
    {
        let storyPlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StoryPlayerViewController") as! StoryPlayerViewController
        
        storyPlayerViewController.currentStory = self.currentStory

        self.navigationController?.pushViewController(storyPlayerViewController, animated: true)
        
    }
    
    
    //MARK:- LiquidFloatingActionButtonDelegate methods
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        
        locationManager.startUpdatingLocation()
    
    
        if index == 0 {
            if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
                if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                    
                    locationManager.startUpdatingLocation()
                    
                    imagePicker.sourceType = .Camera
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    
                    presentViewController(imagePicker, animated: true, completion: {})
                } else {
                    postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
                }
            } else {
                postAlert("Camera inaccessable", message: "Application cannot access the camera.")
            }
        }else if index == 1 {
            
            
            if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
                if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                    
                    imagePicker.sourceType = .Camera
                    imagePicker.mediaTypes = [kUTTypeImage as String]
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
                    
                    presentViewController(imagePicker, animated: true, completion: {})
                } else {
                    postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
                }
            } else {
                postAlert("Camera inaccessable", message: "Application cannot access the camera.")
            }
        }else if index == 2 {
            
            let voiceNoteViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VoiceNoteViewController") as! VoiceNoteViewController
            voiceNoteViewController.delegate = self
                voiceNoteViewController.title = "Audio recorder"
            self.navigationController?.pushViewController(voiceNoteViewController, animated: true)
            
        }else if index == 3 {
            
            locationManager.startUpdatingLocation()
            let noteViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NoteViewController") as! NoteViewController
            noteViewController.delegate = self
            noteViewController.title = "Note recorder"
            self.navigationController?.pushViewController(noteViewController, animated: true)
            
        }else if index == 4 {
            
            
            let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
            branchUniversalObject.title = "My Content Title"
            branchUniversalObject.contentDescription = "My Content Description"
//            branchUniversalObject.imageUrl = "https://example.com/mycontent-12345.png"
            branchUniversalObject.addMetadataKey("property1", value: "blue")
            
            let linkProperties: BranchLinkProperties = BranchLinkProperties()
            linkProperties.feature = "sharing"
            linkProperties.channel = "facebook"
            linkProperties.addControlParam("$ios_url", withValue: "lifemoments://storyID?412414")
            
            
            branchUniversalObject.getShortUrlWithLinkProperties(linkProperties,  andCallback: { (url: String?, error: NSError?) -> Void in
                if error == nil {
                    print("got my Branch link to share: %@", url)
                    
                    
                    let content:FBSDKShareLinkContent = FBSDKShareLinkContent()
                    content.contentURL = NSURL(string: url!)
                    
                    FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
                }
            })
            

            
            
        }
        
        
        
//        NSURL *localURL = [NSURL fileURLWithPath:localPath];
//        To create a local path from an NSURL:
//        
//        NSString *localPath = [localURL filePathURL];
        
        

        print("did Tapped! \(index)")
        liquidFloatingActionButton.close()
        
    }
    
    
    func liquidFloatingHaveClosed(){
        UIView.animateWithDuration(1.0) {
            self.storyPlayerButton?.alpha = 1.0
        }
    }
    
    func liquidFloatingHaveOpend(){        
        UIView.animateWithDuration(0.5) {
            self.storyPlayerButton?.alpha = 0.0
        }
    }
    

    func popToRoot(){
        //self.navigationController!.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func zoomToRegion(){
    
        // it needs to zoom to last known annotaion in the array
        let location = CLLocationCoordinate2D(latitude: (currentStory?._startLatitude)!, longitude: (currentStory?._startLongitude)!)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        mapView.setRegion(region, animated: true)
    }

    func renderPolyLine(){
        for annotation in _locations {
            momentPoints.append(annotation.coordinate)
        }
        let polyline = MKPolyline(coordinates: &momentPoints, count: momentPoints.count)
        mapView.addOverlay(polyline)
    }

    func getMapAnnotations() -> [MomentLocation] {
        
        var annotations:Array = [MomentLocation]()
        if let items = currentStory?._momentsList {
            
            for (index, item) in items.enumerate() {
                
                let lat = item._latitude
                let long = item._longitude
                let type = item._mediaType
                let annotation = MomentLocation(latitude: lat, longitude: long, type: type, momentId: item._momentID)
                annotation.title = "\(item._mediaType)"
                annotations.append(annotation)
            }
            
        }
        return annotations
    }
    
    
    //MARK:- MapViewDelegate methods
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }

        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
            if annotationView == nil {
                
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView!.canShowCallout = false
            }
            else{
                annotationView!.annotation = annotation
            }
        
            let locationAnnotation = annotation as! MomentLocation
            
            if locationAnnotation.type == 0 {
                
                annotationView!.image = UIImage(named: "lifemoments-photo-orange.png")
                
            }else if locationAnnotation.type == 1{
                
                annotationView!.image = UIImage(named: "lifemoments-video-orange.png")
                
            }else if locationAnnotation.type == 2{
                
                annotationView!.image = UIImage(named: "lifemoments-voice-orange.png")
                
            }else if locationAnnotation.type == 3{
                
                annotationView!.image = UIImage(named: "lifemoments-text-orange.png")
                
            }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        print("didSelectAnnotationView")
        
        let currentMomentLocation = view.annotation as? MomentLocation
        let moments = self.currentStory?._momentsList
        
        for moment in moments!.enumerate() {
            
            if moment.element._momentID == currentMomentLocation?.momentID {
             
                if moment.element._mediaType == 0 { // stills
                    
                    let imageDisplayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageDisplayViewController") as! ImageDisplayViewController
                    
                    
                    if let ExistingImageData = moment.element._mediaData{
                        imageDisplayViewController.image = UIImage(data: ExistingImageData, scale: 1.0)
                        self.navigationController?.pushViewController(imageDisplayViewController, animated: true)
                    }
                    

                    
                }else if moment.element._mediaType == 1{ //video
                    
                    let videoData = moment.element._mediaData
                    let paths = NSSearchPathForDirectoriesInDomains(
                        NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    let documentsDirectory: AnyObject = paths[0]
                    let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
                    videoData?.writeToFile(dataPath, atomically: false)
                    
                    let pathURL = NSURL(fileURLWithPath: dataPath, isDirectory: false, relativeToURL: nil)
                    playerView = AVPlayer(URL: pathURL)
                    playerViewController.player = playerView
                    self.presentViewController(playerViewController, animated: true, completion: { 
                        self.playerView.play()
                    })
                    
                }else if moment.element._mediaType == 2{ // audio
                    
                    let audioPlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AudioPlayerViewController") as! AudioPlayerViewController
//                    audioPlayerViewController.delegate = self
                    audioPlayerViewController.title = "Audio recorder"
                    audioPlayerViewController.audioData = moment.element._mediaData
                    self.navigationController?.pushViewController(audioPlayerViewController, animated: true)
                    
                    
                    let audioPlayer = ASAudioPlayer(frame: CGRectMake(0, 50, 300, 100))
                    
//                    let audioData = moment.element._mediaData
//                    let paths = NSSearchPathForDirectoriesInDomains(
//                        NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//                    let documentsDirectory: AnyObject = paths[0]
//                    let dataPath = documentsDirectory.stringByAppendingPathComponent(saveAudioFile)
//                    audioData?.writeToFile(dataPath, atomically: false)
//                    
//                    let pathURL = NSURL(fileURLWithPath: dataPath, isDirectory: false, relativeToURL: nil)
//                    
//                    audioPlayer.setUrl(pathURL)
//                    self.view.addSubview(audioPlayer)
                    
                
                }else if moment.element._mediaType == 3{ // text

                    if let textData = moment.element._mediaData{
                        let text = String(data: textData, encoding: NSUTF8StringEncoding)
                        
                        let noteViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NoteViewController") as! NoteViewController
                        noteViewController.delegate = self
                        noteViewController.title = "Note recorder"
                        noteViewController.textSring = text!
                        noteViewController.editModeEnabled = false
                        noteViewController.currentMomentID = moment.element._momentID
                        self.navigationController?.pushViewController(noteViewController, animated: true)
                        
                    }
                    
                }
                
            
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("")
//        let capital = view.annotation as! Capital
//        let placeName = capital.title
//        let placeInfo = capital.info
        
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
    }
    
    
    func displayImage(imageData: NSData){
        
    }
    
    //MARK:- LocationManagerDelegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue : CLLocationCoordinate2D = manager.location!.coordinate;
        let span2 = MKCoordinateSpanMake(1, 1)
        let long = locValue.longitude;
        let lat = locValue.latitude;
        print(long);
        print(lat);
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        if ((currentStory?._startLatitude) == 0){
            currentStory?._startLatitude = lat
            currentStory?._startLongitude = long
            zoomToRegion()
        }
        
        currentLocation = location
        
        //mapView.centerCoordinate = loadlocation;
        locationManager.stopUpdatingLocation()
    }

    
    // MARK: UIImagePickerControllerDelegate delegate methods
    // Finished recording a video
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            // Save video to the main photo album
            let selectorToCall = Selector("videoWasSavedSuccessfully:didFinishSavingWithError:context:")
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = NSData(contentsOfURL: pickedVideo)
            
            createMoment(videoData!, mediaType: 1)
//            updateMapViewWithNewAnnotations()
            
//            let paths = NSSearchPathForDirectoriesInDomains(
//                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//            let documentsDirectory: AnyObject = paths[0]
//            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
//            videoData?.writeToFile(dataPath, atomically: false)
            
        } else if let pickedPhoto:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage){
             print("Cuaght photo")
            
           var scaledImage = scaleAndRotateImage(pickedPhoto, kMaxResolution: 300)
           print("scaled image \(scaledImage)")
           
            let imageData = UIImagePNGRepresentation(scaledImage)
            
           createMoment(imageData!, mediaType: 0)
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an video
        })
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    // Any tasks you want to perform after recording a video
    func videoWasSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("Video saved")
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // What you want to happen
            })
        }
    }
    
    
    //MARK: Moment creation
    func createMoment(media: AnyObject,mediaType: Int){
        
        let newMoment = Moment()
        newMoment._latitude = (currentLocation?.latitude)!
        newMoment._longitude = (currentLocation?.longitude)!
        
        currentLocation = nil
        
        DBManager.sharedInstance.realm.beginWrite()
        
        newMoment._mediaData = media as? NSData
        newMoment._mediaType = mediaType
        newMoment._momentID = (currentStory?._curentMomentID)! + 1
        currentStory?._curentMomentID = newMoment._momentID
        newMoment._storyId = (currentStory?._storyId)!
        currentStory?._momentsList.append(newMoment)
        
        do {
            try DBManager.sharedInstance.realm.commitWrite()
        }catch{
            print("Error Happend")
        }
        
    }


    // MARK: Utility methods for app
    // Utility method to display an alert to the user.
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateMapViewWithNewAnnotations(){
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotations(self._locations)
        }
    }
    
    
    
    //resize taken image

    func scaleAndRotateImage(image: UIImage, kMaxResolution: CGFloat) -> UIImage {
        var imageCopy: UIImage = image
        if let imgRef: CGImageRef = image.CGImage {
            
            let width = CGFloat(CGImageGetWidth(imgRef))
            let height = CGFloat(CGImageGetHeight(imgRef))
            
            var transform = CGAffineTransformIdentity
            var bounds = CGRectMake(0, 0, width, height)
            
            if width > kMaxResolution || height > kMaxResolution {
                let ratio = width/height
                if ratio > 1 {
                    bounds.size.width = kMaxResolution
                    bounds.size.height = bounds.size.width / ratio
                } else {
                    bounds.size.height = kMaxResolution
                    bounds.size.width = bounds.size.height * ratio
                }
            }
            
            let scaleRatio = bounds.size.width / width
            let imageSize = CGSizeMake(width, height)
            let boundHeight: CGFloat
            let orient: UIImageOrientation = image.imageOrientation
            switch orient {
            case .Up:
                transform = CGAffineTransformIdentity
                
            case .UpMirrored:
                transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0)
                transform = CGAffineTransformScale(transform, -1.0, 1.0)
                
            case .Down:
                transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
                
            case .DownMirrored: //EXIF = 4
                transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
                transform = CGAffineTransformScale(transform, 1.0, -1.0);
                
            case .LeftMirrored: //EXIF = 5
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
                
            case .Left: //EXIF = 6
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
                transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
                
            case .RightMirrored: //EXIF = 7
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeScale(-1.0, 1.0);
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
                
            case .Right: //EXIF = 8
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
            }
            UIGraphicsBeginImageContext(bounds.size)
            
            if let context: CGContextRef = UIGraphicsGetCurrentContext() {
                if orient == .Right || orient == .Left {
                    CGContextScaleCTM(context, -scaleRatio, scaleRatio)
                    CGContextTranslateCTM(context, -height, 0)
                } else {
                    CGContextScaleCTM(context, scaleRatio, -scaleRatio)
                    CGContextTranslateCTM(context, 0, -height)
                }
                
                CGContextConcatCTM(context, transform)
                
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0,0,width,height), imgRef)
                imageCopy = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        return imageCopy
    }

    
    //MARK: - NoteViewControllerDelegate Methods
    func getNoteToSave(note: NSData, currentMomentID: Int) {
        
        if currentMomentID == -1 {
            createMoment(note, mediaType: 3)
        }else{
            for moment in (currentStory?._momentsList)! {
                if moment._momentID == currentMomentID {
                    DBManager.sharedInstance.realm.beginWrite()
                    moment._mediaData = note
                    do {
                        try DBManager.sharedInstance.realm.commitWrite()
                    }catch{
                        print("Error Happend: updateing moment._mediaData")
                    }
                }
            }
        }
        

    }
 
    //MARK: - VoiceNoteViewControllerDelegate Methods
    func getVoiceNoteToSave(voiceNote: NSData) {
        createMoment(voiceNote, mediaType: 2)
    }
    
    // Documents directory
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        return documentsFolderPath
    }
    
    // File in Documents directory
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }

}

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
}

