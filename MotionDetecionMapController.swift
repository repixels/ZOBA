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
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        print("will appear")
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.map.showsUserLocation = true
        self.manager.delegate = self
        manager.startUpdatingLocation()
        let isFirstLocation = true
        let block :(CLLocation,Double)->() = {(location,distance) in
            
            if isFirstLocation {
                self.locationPlist.saveLocation(location)
            }
            let speed = location.speed * 3.6
            if (speed >= 0){
                self.currentSpeed.text = String(Int(speed))
            }
            
            let firstLocationData = self.locationPlist.readFirstLocation()
            let lastLocationData = self.locationPlist.readLastLocation()
            let firstLocation = CLLocation(latitude: firstLocationData.latitude, longitude: firstLocationData.longitude)
            let lastLocation = CLLocation(latitude: lastLocationData.latitude, longitude: lastLocationData.longitude)
            
            self.dist = lastLocation.distanceFromLocation(firstLocation) + location.distanceFromLocation(lastLocation)
            
            
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
            
            let firstDate = firstLocationData.date
            let lastDate = location.timestamp
            
            let hr =  lastDate.hoursFrom(firstDate)
            let min = lastDate.minutesFrom(firstDate) % 60
            let sec = lastDate.secondsFrom(firstDate) % 60
            
            self.timeDisplay.text = "\(hr):\(min):\(sec)"
            
        }
        
        if SessionObjects.motionMonitor != nil {
            SessionObjects.motionMonitor.updateLocationBlock = block
        }
        map.delegate = self
        
        
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
            
        }
        else
        {
            stopReportingBtn.setTitle("Stop Auto Reporting", forState: .Normal)
            
            resetMap()
            
            startDetection(sender)
            manager.startUpdatingLocation()
            self.map.showsUserLocation = true
            
        }
    }
    
    func saveTrip()  {
        
        manager.stopUpdatingLocation()
        self.map.showsUserLocation = false
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
        tripObj = Trip(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trip")
        
        tripObj.vehicle = SessionObjects.currentVehicle
        tripObj.initialOdemeter = SessionObjects.currentVehicle.currentOdemeter
        
        let firstLoc = locationPlist.readFirstLocation()
        
        tripObj.dateAdded = firstLoc.date.timeIntervalSince1970
        
        let distance = locationPlist.getDistanceInKM()
        SessionObjects.currentVehicle.currentOdemeter = Double(SessionObjects.currentVehicle.currentOdemeter!) +  (distance/1000)
        tripObj.coveredKm  = distance ///1000
        tripObj.vehicle?.currentOdemeter = Int(tripObj.vehicle!.currentOdemeter!) + Int(distance)
        tripObj.coordinates = NSSet(array: [firstCoordinate,lastCoordinate])
        
        getLocation(firstCoordinate)
        getLocation(lastCoordinate)
        
        //tripObj.save()
        
        saveTripToWebService(tripObj)
    }
    
    
    func getLocation(coordinate : TripCoordinate){
        
        
        let location = CLLocation(latitude: Double(coordinate.latitude!), longitude: Double(coordinate.longtitude!))
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if places!.count > 0 {
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
        //        map.showAnnotations(map.annotations, animated: true)
        
        
        self.map.fitMapViewToAnnotaionList()
        
        map.reloadInputViews()
        
        var pointsArray = locationPlist.getCoordinatesArray()
        
        var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        if pointsArray.isEmpty
        {
            
            
        }
        else
        {
            for i in 0 ..< pointsArray.count-1
            {
                let coordinate  = CLLocationCoordinate2DMake(pointsArray[i].latitude, pointsArray[i].longitude)
                coordinates.append(coordinate)
            }
            
            let polyline = MKPolyline(coordinates: &coordinates , count: coordinates.count)
            
            self.map.addOverlay(polyline)
        }
    }
    
    var polyLines = [MKPolyline]()
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if (overlay is MKPolyline) {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.flatMintColor()
            renderer.lineWidth = 5
            
            requestSnapshotData(map){ (image, error) in
                if image != nil
                {
                    self.tripObj.image = image
                    
                    self.tripObj.save()
                    
                    let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("map.png")
                    image!.writeToFile(filename, atomically: true)
                    
                }
            }
            
            return renderer
        }
        return MKPolylineRenderer()
    }
    
    
    
    func requestSnapshotData(mapView: MKMapView,  completion: (NSData?, NSError?) -> ()) {
        
        let arrayofCoordinates = locationPlist.getCoordinatesArray()
        
        let firstCoordinate = arrayofCoordinates.first
        let lastCoordinate  = arrayofCoordinates.last
        
        let firstlocation = CLLocation(latitude: CLLocationDegrees((firstCoordinate?.latitude)!), longitude: CLLocationDegrees((firstCoordinate?.longitude)!))
        
        
        
        firstLocationAnnotation.coordinate = firstCoordinate!
        firstLocationAnnotation.title = "Starting Point"
        self.map.addAnnotation(firstLocationAnnotation)
        
        
        
        lastLocationAnnotation.coordinate = lastCoordinate!
        lastLocationAnnotation.title = "Ending Point"
        self.map.addAnnotation(lastLocationAnnotation)
        
        let lastlocation = CLLocation(latitude: CLLocationDegrees((lastCoordinate?.latitude)!), longitude: CLLocationDegrees((lastCoordinate?.longitude)!))
        
        let diffrence = lastlocation.distanceFromLocation(firstlocation)
        
        let longitudeDifference = ((lastCoordinate?.longitude)! + (firstCoordinate?.longitude)!)/2
        
        let lattitudeDifference = ((lastCoordinate?.latitude)! + (firstCoordinate?.latitude)!)/2
        
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
    
    func saveTripToWebService(trip :Trip)
    {
        let tripWebService = TripWebService()
        tripWebService.saveTrip(trip) { (returnedTrip, code) in
            
            
            switch code {
            case "success":
                
                self.saveTripCoordinateToWebService(returnedTrip!, tripCoordinate: trip.coordinates?.allObjects.first as! TripCoordinate)
                
                self.saveTripCoordinateToWebService(returnedTrip!, tripCoordinate: trip.coordinates?.allObjects.last as! TripCoordinate)
                
                trip.tripId = returnedTrip?.tripId
                SessionObjects.currentManageContext.deleteObject(returnedTrip!)
                trip.save()
                break
            case "error" :
                trip.save()
                break
            default:
                break
                
            }
        }
    }
    
    func saveTripCoordinateToWebService(trip : Trip, tripCoordinate : TripCoordinate){
        
        let tripWebService = TripWebService()
        let vehicleId = Int(trip.vehicle!.vehicleId!)
        tripWebService.saveCoordinate(vehicleId, coordinate:  tripCoordinate, tripId: Int(trip.tripId!)){ (returnedCoordinate , code )in
            
            
            switch code {
            case "success":
                SessionObjects.currentManageContext.deleteObject(returnedCoordinate!)
                
                break
            case "error" :
                break
            default:
                break
                
            }
            
        }
        print("coordiate saved")
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
