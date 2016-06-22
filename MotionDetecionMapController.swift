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
    
    var dist : Double = 0.0
    
    var tripObj : Trip!
    
    
    var tripFirstLocation = CLLocation()
    var tripLastLocation = CLLocation()
    var isFirstLocation = true
    
    var lastPlistIndex = 1
    
    var polyLines = [MKPolyline]()
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        print("will appear")
        
        toggleButton()
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map.showsUserLocation = true
        self.manager.delegate = self
        manager.startUpdatingLocation()
        
        let block :(CLLocation,Double)->() = {(location,distance) in
            
            if self.isFirstLocation {
                self.locationPlist.saveLocation(location)
                self.tripFirstLocation = location
                self.tripLastLocation = location
                self.isFirstLocation = false
            }
            let speed = location.speed * 3.6
            if (speed >= 0){
                self.currentSpeed.text = String(Int(speed))
            }
            
            // let firstLocationData = self.locationPlist.readFirstLocation()
            // let lastLocationData = self.locationPlist.readLastLocation()
            // let firstLocation = CLLocation(latitude: firstLocationData.latitude, longitude: firstLocationData.longitude)
            // let lastLocation = CLLocation(latitude: lastLocationData.latitude, longitude: lastLocationData.longitude)
            
            self.dist = self.tripLastLocation.distanceFromLocation(self.tripFirstLocation) + location.distanceFromLocation(self.tripLastLocation)
            
            
            self.totalDistance.text = String.localizedStringWithFormat("%.2f %@", (self.dist/1000),"KM")
            
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
            
            let firstDate = self.tripFirstLocation.timestamp
            let lastDate = location.timestamp
            
            let hr =  lastDate.hoursFrom(firstDate)
            let min = lastDate.minutesFrom(firstDate) % 60
            let sec = lastDate.secondsFrom(firstDate) % 60
            
            self.timeDisplay.text = "\(hr):\(min):\(sec)"
            self.tripLastLocation = location
            
            if self.locationPlist.getCoordinatesArray().count > 5 {
                self.drawRoad()
            }
            
        }
        
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
            self.isFirstLocation = false
        }
        else
        {
            stopReportingBtn.setTitle("Stop Auto Reporting", forState: .Normal)
            
            resetMap()
            self.isFirstLocation = true
            startDetection(sender)
            manager.startUpdatingLocation()
            self.map.showsUserLocation = true
            
        }
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
        
        let distance = dist / 1000
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
    
    
    func drawRoad()
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
            }
            
            for i in lastPlistIndex ..< pointsArray.count
            {
                let coordinate  = CLLocationCoordinate2DMake(pointsArray[i].latitude, pointsArray[i].longitude)
                coordinates.append(coordinate)
            }
            lastPlistIndex = pointsArray.count-1
            
            polyLines.append(MKPolyline(coordinates: &coordinates , count: coordinates.count))
            
            
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
        
        
        
        let firstCoordinate = tripFirstLocation//locationPlist.readFirstLocation()
        let lastCoordinate  = tripLastLocation//locationPlist.readLastLocation()
        
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
        currentSpeed.text = "0"
        self.elapsedTimeLabel.text = "00:00:00"
        self.totalDistance.text = "0"
        
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
