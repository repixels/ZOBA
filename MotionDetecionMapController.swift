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
    
    
    @IBOutlet weak var currentSpeed: UILabel!
    
    @IBOutlet weak var totalDistance: UILabel!
    
    
    @IBOutlet weak var stopReportingBtn: UIButton!
    
    let annotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    var lat : Double?
    var long :Double?
    var endlat : Double?
    var endlong : Double?
    var locationPlist = LocationPlistManager()
    
    @IBOutlet weak var autoReportingControlButton: UIButton!
    
    @IBOutlet weak var speedMeasuringUnitLabel: UILabel!
    
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    
    
    let manager  = CLLocationManager()
    var monitor : LocationMonitor! = nil
    var image : NSData?
    var point = NSMutableDictionary()
    
     var isStop = String(Defaults[.isHavingTrip])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.showsUserLocation = true
        self.manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let block :(Double,Double)->() = {(speed,distance) in
            
            
            self.currentSpeed.text = String(Int(speed))
            print("received  : \(speed)")
            self.totalDistance.text = String.localizedStringWithFormat("%.2f %@", distance,"Km")
            
           // for i in 0 ..< speedArray.count-1 {
                //let speed = locationPlist.getSpeed(i)
                if speed < 30 {
                    
                    self.currentSpeed.textColor = UIColor.greenColor()
                    
                }
                else if speed < 80
                {
                    self.currentSpeed.textColor = UIColor.yellowColor()
                    
                }
                else
                {
                    self.currentSpeed.textColor = UIColor.redColor()
                }
                
                
           // }
        }
        
        SessionObjects.motionMonitor.updateLocationBlock = block
        map.delegate = self
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        annotation.coordinate = (locations.first?.coordinate)!
        self.map.addAnnotation(annotation)
        self.map.centerCoordinate = annotation.coordinate
        
    }
    @IBAction func stopDetecionTapped(sender: AnyObject) {
        
        if  Defaults[.isHavingTrip]
        {
            SessionObjects.motionMonitor.stopTrip()
            stopReportingBtn.setTitle("Start Auto Reporting", forState: .Normal)
            
            drawRoad()
            let point = locationPlist.getLocationsDictionaryArray()
            
            let firstCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
            firstCoordinate.latitude =  point.firstObject?.objectForKey("latitude") as? NSDecimalNumber
            firstCoordinate.longtitude = point.firstObject?.objectForKey("longitude") as? NSDecimalNumber
            
            let lastCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
            
            
            lastCoordinate.latitude = point.lastObject?.objectForKey("latitude") as? NSDecimalNumber
            lastCoordinate.longtitude = point.lastObject?.objectForKey("longitude") as? NSDecimalNumber
            
            let tripObj = Trip(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trip")
            
            let distance = locationPlist.getDistanceInKM()
            
            tripObj.coveredKm  = distance
            tripObj.coordinates = NSSet(array: [firstCoordinate,lastCoordinate])
            
            tripObj.save()
        }
        else
        {
            
            startDetection(sender)
         
            stopReportingBtn.setTitle("Stop Auto Reporting", forState: .Normal)

        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Zoba", message: "looks like you are moving  ", preferredStyle: .Alert)
        
        let activateAutoReport = UIAlertAction(title: "Auto report", style:.Default) { (action) in
            print("auto reprt started")
            SessionObjects.motionMonitor.startNewTrip()
            //            self.havingTripTextField.text = String(Defaults[.isHavingTrip])
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
    
     func startDetection(sender: AnyObject) {
        
        SessionObjects.motionMonitor.startNewTrip()
        
        let speedArray = locationPlist.getLocationsDictionaryArray()


    }
    
    
    func drawRoad()
    {
        
        var ArrayOfpoint = locationPlist.getCoordinatesArray()
        
        var polyline : MKPolyline?
        for i in 0 ..< ArrayOfpoint.count-1
        {
            let first = ArrayOfpoint[i]
            let second = ArrayOfpoint[i+1]
            var arr = [first,second]
            polyline = MKPolyline(coordinates: &arr , count: arr.count)
            self.map.addOverlay(polyline!)
            
        }
        
        let mapOvelay = map.overlays.last
        map.addOverlay(mapOvelay!)
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.greenColor()
        renderer.lineWidth = 10
        
        
        requestSnapshotData(map) { (image, error) in
            
            // return image!.drawLayer(mapView.overlays.first as! CALayer, inContext: mapView)
            
        }
        
        return renderer
    }
    
    func requestSnapshotData(mapView: MKMapView,  completion: (NSData?, NSError?) -> ()) {
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
