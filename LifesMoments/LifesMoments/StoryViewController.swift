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


enum CurrentStoryMode: Int {
    case Editor = 0
    case Viewer = 1
}


class StoryViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,LiquidFloatingActionButtonDataSource,LiquidFloatingActionButtonDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var audioRecorder:AVAudioRecorder!
    var currentStory: Story?
    var storyControllerMode: CurrentStoryMode?
    let locationManager: CLLocationManager = CLLocationManager()
    var momenPoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    
    var _locations: [MomentLocation] = [MomentLocation(latitude: -23.595571, longitude: -46.684408), MomentLocation(latitude: -23.597886, longitude: -46.673950),
        MomentLocation(latitude: -23.597886, longitude: -46.673950), MomentLocation(latitude: -23.597591, longitude: -46.666805),
        MomentLocation(latitude: -23.597591, longitude: -46.666805), MomentLocation(latitude: -23.604061, longitude: -46.662728)]

    
    //video example 2
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        mapView.addAnnotations(_locations)
        zoomToRegion()
        renderPolyLine()

        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if ((currentStory?._startLatitude) == nil){
            locationManager.startUpdatingLocation()
        }

        
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
        
        cells.append(cellFactory("image2"))
        cells.append(cellFactory("image3"))
        cells.append(cellFactory("image4"))
        cells.append(cellFactory("image5"))
        
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 82, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        
        self.mapView.addSubview(bottomRightButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- LiquidFloatingActionButtonDelegate methods
    
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
    
        if index == 0 {
            if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
                if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                    
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
            //VoiceNoteViewController
            
            let voiceNoteViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VoiceNoteViewController") as! VoiceNoteViewController
            self.navigationController?.pushViewController(voiceNoteViewController, animated: true)
        }else if index == 3 {
            //for note / text
        }

        print("did Tapped! \(index)")
        liquidFloatingActionButton.close()
    }
    

    func popToRoot(){//(sender:UIBarButtonItem){
        //        self.navigationController!.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func zoomToRegion(){ //TODO: add locatoin to zoom to
    
        let location = CLLocationCoordinate2D(latitude: -23.597886, longitude: -46.673950)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        mapView.setRegion(region, animated: true)
    }

    func renderPolyLine(){
        for annotation in _locations {
            momenPoints.append(annotation.coordinate)
        }
        let polyline = MKPolyline(coordinates: &momenPoints, count: momenPoints.count)
        mapView.addOverlay(polyline)
    }
    
    //TODO: look at it later an modife it to work thorugh a story
    func getMapAnnotations() -> [MomentLocation] {
        
        var annotations:Array = [MomentLocation]()
        
        //load plist file
        var stations: NSArray?
        if let path = NSBundle.mainBundle().pathForResource("stations", ofType: "plist") {
            stations = NSArray(contentsOfFile: path)
        }
        
        //iterate and create annotations
        if let items = stations {
            for item in items {
                let lat = item.valueForKey("lat") as! Double
                let long = item.valueForKey("long")as! Double
                let annotation = MomentLocation(latitude: lat, longitude: long)
                annotation.title = item.valueForKey("title") as? String
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
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        //TODO: fix this so each annotation will get its proper icon
        for annotation in _locations{
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView!.canShowCallout = false
                annotationView!.image = UIImage(named: "image2.png")
                //annotationView!.rightCalloutAccessoryView = detailButton
            }
            else{
                annotationView!.annotation = annotation
            }
        }

        
        return annotationView
    }
    
    
    
    //MARK:- LocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue : CLLocationCoordinate2D = manager.location!.coordinate;
        let span2 = MKCoordinateSpanMake(1, 1)
        let long = locValue.longitude;
        let lat = locValue.latitude;
        print(long);
        print(lat);
        let loadlocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        if ((currentStory?._startLatitude) == nil){
            currentStory?._startLatitude = lat
            currentStory?._startLongitude = long
        }
        
        //mapView.centerCoordinate = loadlocation;
        locationManager.stopUpdatingLocation()
    }

    
    // MARK: UIImagePickerControllerDelegate delegate methods
    // Finished recording a video
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        print("Got a video")
        
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            // Save video to the main photo album
            let selectorToCall = Selector("videoWasSavedSuccessfully:didFinishSavingWithError:context:")
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = NSData(contentsOfURL: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
            videoData?.writeToFile(dataPath, atomically: false)
            
        } else if let pickedPhoto:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage){
             print("Cuaght photo")
            
           var scaledImage = scaleAndRotateImage(pickedPhoto, kMaxResolution: 300)
           print("scaled image \(scaledImage)")
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

    // MARK: Utility methods for app
    // Utility method to display an alert to the user.
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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

}

