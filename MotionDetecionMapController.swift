//
//  MotionDetecionMapController.swift
//  ZOBA
//
//  Created by Angel mas on 6/15/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import MapKit
import TextFieldEffects
import SwiftyUserDefaults

class MotionDetecionMapController: UIViewController ,CLLocationManagerDelegate ,MKMapViewDelegate{
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var currentSpeed: HoshiTextField!
    @IBOutlet weak var totalDistance: HoshiTextField!
    @IBOutlet weak var havingTripTextField: HoshiTextField!
    
    let annotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    var lat : Double?
    var long :Double?
    var endlat : Double?
    var endlong : Double?
    var locationPlist = LocationPlistManager()
    let manager  = CLLocationManager()
    var monitor : LocationMonitor! = nil
    var image : NSData?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.showsUserLocation = true
        self.manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let block :(Double,Double)->() = {(speed,distance) in
            
            self.currentSpeed.text = String.localizedStringWithFormat("%.2f %@", speed, " Km/Hr")
            self.totalDistance.text = String.localizedStringWithFormat("%.2f %@", distance, " Km")
            self.havingTripTextField.text = String(Defaults[.isHavingTrip])
        }
        
        SessionObjects.motionMonitor.updateLocationBlock = block
        map.reloadInputViews()
        map.delegate = self
        
    }
 
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        annotation.coordinate = (locations.first?.coordinate)!
        self.map.addAnnotation(annotation)
        //self.map.centerCoordinate = annotation.coordinate
        
    }
    @IBAction func stopDetecionTapped(sender: AnyObject) {
        SessionObjects.motionMonitor.stopTrip()
        self.havingTripTextField.text = String(Defaults[.isHavingTrip])
        drawRoad()
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Zoba", message: "looks like you are moving  ", preferredStyle: .Alert)
        
        let activateAutoReport = UIAlertAction(title: "Auto report", style:.Default) { (action) in
            print("auto reprt started")
            SessionObjects.motionMonitor.startNewTrip()
            self.havingTripTextField.text = String(Defaults[.isHavingTrip])
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .Cancel, handler: nil)
        
        alert.addAction(activateAutoReport)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showStopAlert() {
        
        let alert = UIAlertController(title: "Zoba", message: "you have stopped  ", preferredStyle: .Alert)
        
        let stopAutoReport = UIAlertAction(title: "ok", style:.Default) { (action) in
            
            SessionObjects.motionMonitor.stopTrip()
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "cancel", style:.Default) { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        alert.addAction(stopAutoReport)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func startDetection(sender: AnyObject) {
        
        SessionObjects.motionMonitor.startNewTrip()
        
        map.reloadInputViews()
    }
    
    
    func drawRoad()
    {
        var point = NSMutableDictionary()
        
        point = locationPlist.getLocationDictionaryAt(0)
        
        lat = (point.objectForKey("latitude") as! NSString).doubleValue
        long = (point.objectForKey("longitude") as! NSString).doubleValue
        
        
        point = locationPlist.getLocationDictionaryAt(4)
        endlat = (point.objectForKey("latitude") as! NSString).doubleValue
        endlong = (point.objectForKey("longitude") as! NSString).doubleValue
        
        let sourceLocation = CLLocationCoordinate2D(latitude: lat!,longitude: long!)
        let destinationLocation = CLLocationCoordinate2D(latitude: endlat!, longitude: endlong!)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .Automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculateDirectionsWithCompletionHandler {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.map.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 4.0
        
        requestSnapshotData(mapView) { (image, error) in
            
            print("image save")
        }
        
        return renderer
    }
    
    func requestSnapshotData(mapView: MKMapView, completion: (NSData?, NSError?) -> ()) {
        let options = MKMapSnapshotOptions()
        options.region = mapView.region
        options.size = mapView.frame.size
        options.scale = UIScreen.mainScreen().scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler() { snapshot, error in
            guard snapshot != nil else {
                completion(nil, error)
                return
            }
            
            let image = snapshot!.image
            let data = UIImagePNGRepresentation(image)
            let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("map.png")
            data!.writeToFile(filename, atomically: true)
            
            print(filename)
            
            completion(data, nil)
        }
    }
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
