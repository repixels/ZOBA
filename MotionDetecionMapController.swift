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
    
    
    @IBOutlet weak var timeDisplay: UILabel!
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
            
                if speed < 30 {
                    
                    self.currentSpeed.textColor = UIColor.flatGreenColor()
                }
                else if speed < 80
                {
                    self.currentSpeed.textColor = UIColor.flatYellowColor()
                    
                }
                else
                {
                    self.currentSpeed.textColor = UIColor.redColor()
                }
            
            let firstDate = self.locationPlist.readFirstLocation().date
            let lastDate = self.locationPlist.readLastLocation().date

           let hr =  lastDate.hoursFrom(firstDate)
           let min = lastDate.minutesFrom(firstDate) % 60
           let sec = lastDate.secondsFrom(firstDate) % 60

            
            self.timeDisplay.text = "\(hr):\(min):\(sec)"
           
        }
        
        SessionObjects.motionMonitor.updateLocationBlock = block
        map.delegate = self
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        annotation.coordinate = (locations.first?.coordinate)!
        self.map.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        self.map.setRegion(region, animated: true)
    }
    @IBAction func stopDetecionTapped(sender: AnyObject) {
        
        let firstLoc = locationPlist.readFirstLocation()
        
        if  Defaults[.isHavingTrip]
        {
            SessionObjects.motionMonitor.stopTrip()
            stopReportingBtn.setTitle("Start Auto Reporting", forState: .Normal)
            
            drawRoad()
            
            let point = locationPlist.getLocationsDictionaryArray()
            
    
            let firstCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
            firstCoordinate.latitude =  NSDecimalNumber(string: point.firstObject?.objectForKey("latitude") as? String)
            firstCoordinate.longtitude = NSDecimalNumber(string: point.firstObject?.objectForKey("longitude") as? String)
            
            let lastCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
           
            lastCoordinate.latitude = NSDecimalNumber(string: point.lastObject?.objectForKey("latitude") as? String)
            lastCoordinate.longtitude = NSDecimalNumber(string: point.lastObject?.objectForKey("longitude") as? String)
            
            let tripObj = Trip(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trip")
            tripObj.vehicle = SessionObjects.currentVehicle
            tripObj.initialOdemeter = SessionObjects.currentVehicle.currentOdemeter
            
            tripObj.dateAdded = firstLoc.date.timeIntervalSince1970
            
            let distance = locationPlist.getDistanceInKM()
            print(SessionObjects.currentVehicle.currentOdemeter)
            SessionObjects.currentVehicle.currentOdemeter = Double(SessionObjects.currentVehicle.currentOdemeter!) +  (distance/1000)
            print(SessionObjects.currentVehicle.currentOdemeter)
            print(distance)
            tripObj.coveredKm  = distance
            print(tripObj.coveredKm)
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


    }
    
    
    func drawRoad()
    {
        
        var pointsArray = locationPlist.getCoordinatesArray()
        
        
        if pointsArray.isEmpty
        {
            
        }
        else
        {
            
            var polyline : MKPolyline?
            for i in 0 ..< pointsArray.count-1
            {
                let first = pointsArray[i]
                let second = pointsArray[i+1]
                var arr = [first,second]
                polyline = MKPolyline(coordinates: &arr , count: arr.count)
                self.map.addOverlay(polyline!)
                
            }
            
            let mapOvelay = map.overlays.last
            map.addOverlay(mapOvelay!)
        }
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.flatRedColor()
        renderer.lineWidth = 9
        
        
        requestSnapshotData(map) { (image, error) in
        print(error)}
        
        return renderer
    }
    
    func requestSnapshotData(mapView: MKMapView,  completion: (NSData?, NSError?) -> ()) {
        let options = MKMapSnapshotOptions()
        
        let arrayofLocations = locationPlist.getCoordinatesArray()
        
        
        let firstCoordinate = arrayofLocations.first
        let lastCoordinate  = arrayofLocations.last
        
        
        let firstlocation = CLLocation(latitude: CLLocationDegrees((firstCoordinate?.latitude)!), longitude: CLLocationDegrees((firstCoordinate?.longitude)!))
        
        let lastlocation = CLLocation(latitude: CLLocationDegrees((lastCoordinate?.latitude)!), longitude: CLLocationDegrees((lastCoordinate?.longitude)!))
        
        
        let diffrence = lastlocation.distanceFromLocation(firstlocation)
        
        print(diffrence)
        
        let region =  MKCoordinateRegionMakeWithDistance(firstlocation.coordinate, diffrence, diffrence)
    

        options.region = region
        options.size = mapView.frame.size
        options.scale = UIScreen.mainScreen().scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler() { snapshot, error in
            guard snapshot != nil else {
                completion(nil, error)
                return
            }
            
            UIGraphicsBeginImageContext(self.map.frame.size)
            self.map.drawViewHierarchyInRect(self.map.bounds, afterScreenUpdates: true)
            let imageee = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            let data = UIImagePNGRepresentation(imageee)
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
