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
import FoldingTabBar

class MotionDetecionMapController: UIViewController ,CLLocationManagerDelegate ,MKMapViewDelegate , UIScrollViewDelegate , YALTabBarViewDelegate , YALTabBarInteracting
{    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var currentSpeed: UILabel!
    
    @IBOutlet weak var totalDistance: UILabel!
    
    @IBOutlet weak var stopReportingBtn: UIButton!
    
    @IBOutlet weak var speedMeasuringUnitLabel: UILabel!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    
    let annotation = MKPointAnnotation()
    var locationPlist = LocationPlistManager()
    
    let manager  = CLLocationManager()
    var point = NSMutableDictionary()
    
    var isStop = String(Defaults[.isHavingTrip])
    
    var newregion : MKCoordinateRegion!
    
    
    
    let firstLocationAnnotation = MKPointAnnotation()
    let lastLocationAnnotation = MKPointAnnotation()
    var polyline : MKPolyline!
    
    static var  dist : Double = 0.0
    
    var tripObj : Trip!
    
    
    static var tripFirstLocation = CLLocation()
    static var tripLastLocation = CLLocation()
    static var isFirstLocation = true
    static var lastDate : NSDate!
    var lastPlistIndex = 1
    
    var polyLines = [MKPolyline]()
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        print("will appear")
        
        
        self.totalDistance.text = String.localizedStringWithFormat("%.2f %@", (MotionDetecionMapController.dist/1000),"KM")
        
        
        
        if MotionDetecionMapController.lastDate != nil {
            let firstDate = MotionDetecionMapController.tripFirstLocation.timestamp
            let hr =  MotionDetecionMapController.lastDate.hoursFrom(firstDate)
            let min = MotionDetecionMapController.lastDate.minutesFrom(firstDate) % 60
            let sec = MotionDetecionMapController.lastDate.secondsFrom(firstDate) % 60
            
            self.timeDisplay.text = "\(hr):\(min):\(sec)"
        }
        toggleButton()
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map.showsUserLocation = true
        self.manager.delegate = self
        manager.startUpdatingLocation()
        self.manager.startUpdatingHeading()
        //start of block
        let block :(CLLocation,Double)->() = {(location,distance) in
            
            
            if MotionDetecionMapController.isFirstLocation {
                self.locationPlist.saveLocation(location)
                MotionDetecionMapController.tripFirstLocation = location
                MotionDetecionMapController.tripLastLocation = location
                MotionDetecionMapController.isFirstLocation = false
                
            }
            let speed = location.speed * 3.6
            if (speed >= 0){
                self.currentSpeed.text = String(Int(speed))
            }
            
            
            MotionDetecionMapController.dist = MotionDetecionMapController.tripLastLocation.distanceFromLocation(MotionDetecionMapController.tripFirstLocation) + location.distanceFromLocation(MotionDetecionMapController.tripLastLocation)
            
            
            self.totalDistance.text = String.localizedStringWithFormat("%.2f %@", (MotionDetecionMapController.dist/1000),"KM")
            
            if speed < 30 {
                
                self.currentSpeed.textColor = UIColor.flatGreenColor()
            }
            else if speed < 100
            {
                self.currentSpeed.textColor = UIColor.flatYellowColor()
                
            }
            else
            {
                self.currentSpeed.textColor = UIColor.redColor()
            }
            
            let firstDate = MotionDetecionMapController.tripFirstLocation.timestamp
            MotionDetecionMapController.lastDate = location.timestamp
            
            let hr =  MotionDetecionMapController.lastDate.hoursFrom(firstDate)
            let min = MotionDetecionMapController.lastDate.minutesFrom(firstDate) % 60
            let sec = MotionDetecionMapController.lastDate.secondsFrom(firstDate) % 60
            
            self.timeDisplay.text = "\(hr):\(min):\(sec)"
            MotionDetecionMapController.tripLastLocation = location
            
         //   if self.locationPlist.getCoordinatesArray().count > 5 {
                self.preparePolyLines()
                
           // }
            
        }
        // end of block
        
        
        if SessionObjects.motionMonitor != nil {
            SessionObjects.motionMonitor.updateLocationBlock = block
        }else {
            SessionObjects.motionMonitor = LocationMonitor()
            SessionObjects.motionMonitor.updateLocationBlock = block
        }
        
        map.delegate = self
        
        let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController!.tabBar.frame), 0);
        self.scrollView.contentInset = adjustForTabbarInsets;
        self.scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
        
        if SessionObjects.currentVehicle == nil {
            
            self.stopReportingBtn .enabled = false
            self.stopReportingBtn.setTitle("No Available Vehicle To report", forState: .Disabled)
            self.stopReportingBtn.backgroundColor = UIColor.grayColor()
        }
        else {
            
            toggleButton()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: locations.first!.coordinate, span: span)
        self.map.setRegion(region, animated: true)
        
    }
    @IBAction func stopDetecionTapped(sender: AnyObject) {
        
        if  Defaults[.isHavingTrip]
        {
            saveTrip()
            print("points count  =====> \(self.locationPlist.getCoordinatesArray().count)")
            MotionDetecionMapController.isFirstLocation = false
        }
        else
        {
            stopReportingBtn.setTitle("Stop Auto Reporting", forState: .Normal)
            
            resetMap()
            MotionDetecionMapController.isFirstLocation = true
            startDetection(sender)
            manager.startUpdatingLocation()
            self.map.showsUserLocation = true
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("===================================")
        print(newHeading.trueHeading)
        
    }
    
    func saveTrip()  {
        
        
        self.map.addOverlays(polyLines)
        
        
        manager.stopUpdatingLocation()
        self.map.showsUserLocation = false
        SessionObjects.motionMonitor.stopTrip()
        stopReportingBtn.setTitle("Start Auto Reporting", forState: .Normal)
        
        createMapImageWithPolyline()
        
        let point = locationPlist.getLocationsDictionaryArray()
        
        let firstCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
        firstCoordinate.latitude =  NSDecimalNumber(string: point.firstObject?.objectForKey("latitude") as? String)
        firstCoordinate.longtitude = NSDecimalNumber(string: point.firstObject?.objectForKey("longitude") as? String)
        
        let lastCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
        
        lastCoordinate.latitude = NSDecimalNumber(string: point.lastObject?.objectForKey("latitude") as? String)
        lastCoordinate.longtitude = NSDecimalNumber(string: point.lastObject?.objectForKey("longitude") as? String)
        
        tripObj = Trip(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trip")
        
        tripObj.vehicle = SessionObjects.currentVehicle
        print(SessionObjects.currentVehicle!.vehicleId!)
        tripObj.initialOdemeter = SessionObjects.currentVehicle.currentOdemeter
        
        let firstLoc = locationPlist.readFirstLocation()
        
        tripObj.dateAdded = firstLoc.date.timeIntervalSince1970
        
        let distance = MotionDetecionMapController.dist / 1000
        SessionObjects.currentVehicle.currentOdemeter = Double(SessionObjects.currentVehicle.currentOdemeter!) +  (distance)
        
        print("Distance is: \(distance)")
        tripObj.coveredKm  = distance ///1000
        tripObj.vehicle?.currentOdemeter = Int(tripObj.vehicle!.currentOdemeter!) + Int(distance)
        tripObj.coordinates = NSSet(array: [firstCoordinate,lastCoordinate])
        
        getLocation(firstCoordinate)
        getLocation(lastCoordinate)
        
        saveTripToWebService(tripObj)
    }
    
    
    
    func saveTripToWebService(trip :Trip)
    {
        let tripWebService = TripWebService()
        tripWebService.saveTrip(trip) { (returnedTrip, code) in
            
            
            switch code {
            case "success":
                
                self.saveTripCoordinateToWebService(returnedTrip!, tripCoordinate: trip.coordinates?.allObjects.first as! TripCoordinate)
                
                self.saveTripCoordinateToWebService(returnedTrip!, tripCoordinate: trip.coordinates?.allObjects.last as! TripCoordinate)
                
                
                SessionObjects.currentManageContext.deleteObject(returnedTrip!)
                trip.tripId = returnedTrip?.tripId
                trip.save()
                print("trip saved")
                break
            case "error" :
                print("error in saving")
                trip.save()
                break
            default:
                break
                
            }
        }
    }
    
    func saveTripCoordinateToWebService(trip : Trip, tripCoordinate : TripCoordinate){
        
        let tripWebService = TripWebService()
        tripWebService.saveCoordinate(Int(SessionObjects.currentVehicle.vehicleId!), coordinate:  tripCoordinate, tripId: Int(trip.tripId!)){ (returnedCoordinate , code )in
            
            
            switch code {
            case "success":
                print("saving cooridnate")
                tripCoordinate.coordinateId = returnedCoordinate?.coordinateId
                
                SessionObjects.currentManageContext.deleteObject(returnedCoordinate!)
                
                break
            case "error" :
                print("error on saving coordinate")
                break
            default:
                break
                
            }
            
        }
        print("coordiate saved")
        
    }
    
    
    
    
    
    func getLocation(coordinate : TripCoordinate){
        
        
        let location = CLLocation(latitude: Double(coordinate.latitude!), longitude: Double(coordinate.longtitude!))
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
            dispatch_async(dispatch_get_main_queue(), {
                
                if places != nil && places!.count > 0 {
                    coordinate.address =  places!.first?.name
                    coordinate.save()
                }
            })
            
            
        })
        
    }
    
    
    func startDetection(sender: AnyObject) {
        self.map.removeAnnotations(map.annotations)
        SessionObjects.motionMonitor.startNewTrip()
    }
    
    
    func preparePolyLines()
    {
        
        map.reloadInputViews()
        
        var pointsArray = locationPlist.getCoordinatesArray()
        //        locationPlist.clearPlist()
        var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        
        if pointsArray.isEmpty
        {
            
            
        }
        else
        {
            
            if lastPlistIndex > pointsArray.count-1
            {
                lastPlistIndex = 1
            }else if lastPlistIndex > 0 {
                
                lastPlistIndex -= 1
            }
            
            polyLines.removeAll()
            
            for i in lastPlistIndex ..< pointsArray.count
            {
                let coordinate  = CLLocationCoordinate2DMake(pointsArray[i].latitude, pointsArray[i].longitude)
                coordinates.append(coordinate)
            }
            lastPlistIndex = pointsArray.count-1
            
            polyLines.append(MKPolyline(coordinates: &coordinates , count: coordinates.count))
           // self.map.addOverlays(polyLines)

            
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if (overlay is MKPolyline) {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.flatMintColor()
            renderer.lineWidth = 5
            
            return renderer
        }
        return MKPolylineRenderer()
    }
    
    
    func createMapImageWithPolyline()
    {
        self.map.fitMapViewToAnnotaionList()
        requestSnapshotData(map){ (image, error) in
            if image != nil
            {
                self.tripObj.image = image
                
                self.tripObj.save()
                
                let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("map.png")
                image!.writeToFile(filename, atomically: true)
                
            }
        }
    }
    
    
    func requestSnapshotData(mapView: MKMapView,  completion: (NSData?, NSError?) -> ()) {
        
        
        
        let firstCoordinate = MotionDetecionMapController.tripFirstLocation//locationPlist.readFirstLocation()
        let lastCoordinate  = MotionDetecionMapController.tripLastLocation//locationPlist.readLastLocation()
        
        let firstlocation = CLLocation(latitude: CLLocationDegrees((firstCoordinate.coordinate.latitude)), longitude: CLLocationDegrees((firstCoordinate.coordinate.longitude)))
        let lastlocation = CLLocation(latitude: CLLocationDegrees((lastCoordinate.coordinate.latitude)), longitude: CLLocationDegrees((lastCoordinate.coordinate.longitude)))
        
        
        
        firstLocationAnnotation.coordinate = firstlocation.coordinate
        firstLocationAnnotation.title = "Starting Point"
        self.map.addAnnotation(firstLocationAnnotation)
        
        
        
        lastLocationAnnotation.coordinate = lastlocation.coordinate
        
        lastLocationAnnotation.title = "Ending Point"
        self.map.addAnnotation(lastLocationAnnotation)
        
        
        
        let diffrence = lastlocation.distanceFromLocation(firstlocation)
        
        let longitudeDifference = ((lastCoordinate.coordinate.longitude) + (firstlocation.coordinate.longitude))/2
        
        let lattitudeDifference = ((lastCoordinate.coordinate.latitude) + (firstCoordinate.coordinate.latitude))/2
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: lattitudeDifference, longitude: longitudeDifference)
        
        let region =  MKCoordinateRegionMakeWithDistance(centerCoordinate, diffrence, diffrence)
        
        let options = MKMapSnapshotOptions()
        options.region = region
        options.size = mapView.frame.size
        options.scale = UIScreen.mainScreen().scale
        
        self.map.setRegion(region, animated: true)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler() { snapshot, error in
            guard snapshot != nil else {
                completion(nil, error)
                return
            }
            
            UIGraphicsBeginImageContext(self.map.frame.size)
            self.map.drawViewHierarchyInRect(self.map.bounds, afterScreenUpdates: true)
            let finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            completion(UIImagePNGRepresentation(finalImage) , error)
            return
        }
    }
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func resetMapZoom(firstAnnotation : MKAnnotation , secondAnnotation : MKAnnotation)
    {
        
        map.showAnnotations(map.annotations, animated: true)
    }
    
    func toggleButton()  {
        
        if Defaults[.isHavingTrip] {
            if stopReportingBtn != nil {
                stopReportingBtn.setTitle("Stop Auto Reporting", forState: .Normal)
            }
        }else{
            if stopReportingBtn != nil {
                stopReportingBtn.setTitle("Start Auto Reporting", forState: .Normal)
            }
        }
        
    }
    
    
    func resetMap(){
        
        if( self.map != nil )
        {
            
            self.map.removeOverlays(self.map.overlays)
            self.map.reloadInputViews()
        }
        
    }
    
    func clearView(){
        
        toggleButton()
        //        currentSpeed.text = "0"
        //        self.elapsedTimeLabel.text = "00:00:00"
        //        self.totalDistance.text = "0"
        
    }
    
    
    
}

extension MKMapView {
    func fitMapViewToAnnotaionList() -> Void {
        let mapEdgePadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        var zoomRect:MKMapRect = MKMapRectNull
        
        for index in 0..<self.annotations.count {
            let annotation = self.annotations[index]
            let aPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            let rect:MKMapRect = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
            
            if MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        self.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
    }
    
}
/*
 class Point:NSObject{
 
 var firstPoint : CLLocationCoordinate2D!
 var secondPoint : CLLocationCoordinate2D!
 var thirdPoint : CLLocationCoordinate2D!
 var newArr : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
 
 func tst(){
 
 var i = 0
 let plist = LocationPlistManager()
 let arr  = plist.getCoordinatesArray()
 print("count of old arr : \(arr.count)")
 print("started")
 while i < arr.count {
 
 if firstPoint == nil{
 firstPoint = arr[i]
 newArr.append(arr[i])
 }else if secondPoint == nil {
 secondPoint = arr[i]
 newArr.append(arr[i])
 
 
 }else if !isOnTheSameLine(firstPoint,secondPoint: secondPoint,thirdPoint: arr[i]){
 
 newArr.append(arr[i])
 firstPoint = arr[i]
 secondPoint = nil
 }
 
 
 
 i += 1
 }
 print("finished")
 print("count of new arr : \(newArr.count)")
 
 }
 
 func savePoint(point : CLLocationCoordinate2D){
 if firstPoint == nil{
 firstPoint = point
 newArr.append(point)
 print("first point is nil and count : \(newArr.count)")
 }else if secondPoint == nil {
 secondPoint = point
 newArr.append(point)
 print("second point is nil and count : \(newArr.count)")
 
 }else if !isOnTheSameLine(firstPoint,secondPoint: secondPoint,thirdPoint: point){
 
 newArr.removeLast()
 newArr.append(point)
 firstPoint = point
 secondPoint = nil
 print("not on the same line and count : \(newArr.count)")
 }
 
 
 
 }
 
 func getArray()->([CLLocationCoordinate2D]){
 
 return newArr
 }
 
 
 func isOnTheSameLine(firstPoint : CLLocationCoordinate2D ,secondPoint : CLLocationCoordinate2D ,thirdPoint :CLLocationCoordinate2D)->(Bool){
 let v1 = firstPoint.latitude * (secondPoint.longitude - thirdPoint.longitude)
 let v2 = secondPoint.latitude * (thirdPoint.longitude - firstPoint.longitude)
 let v3 = thirdPoint.latitude * (firstPoint.longitude - secondPoint.longitude)
 
 //        let onTheSameLine = Math.ABS(v1 + v2 + v3)
 let result = ((v1 + v2 + v3) < 0.000005) && ((v1 + v2 + v3) > -0.000005)
 //        print("")
 print("(v1 + v2 + v3) ==> \(v1 + v2 + v3) and is on the same line \(result)")
 
 return result
 }
 
 }*/