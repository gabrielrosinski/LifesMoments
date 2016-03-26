//
//  StoryViewController.swift
//  LifesMoments
//
//  Created by Gabriel on 3/23/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import MapKit


enum CurrentStoryMode: Int {
    case Editor = 0
    case Viewer = 1
}


class StoryViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var currentStory: Story?
    let locationManager: CLLocationManager = CLLocationManager()
    var momenPoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    
    
    
    var _locations: [MomentLocation] = [MomentLocation(latitude: -23.595571, longitude: -46.684408), MomentLocation(latitude: -23.597886, longitude: -46.673950),
        MomentLocation(latitude: -23.597886, longitude: -46.673950), MomentLocation(latitude: -23.597591, longitude: -46.666805),
        MomentLocation(latitude: -23.597591, longitude: -46.666805), MomentLocation(latitude: -23.604061, longitude: -46.662728)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        mapView.addAnnotations(_locations)
        zoomToRegion()
        
        
        renderPolyLine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
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
}
