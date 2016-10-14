//
//  LocationMonitor.swift
//  UserScreen
//
//  Created by me on 5/21/16.
//  Copyright © 2016 Zooba. All rights reserved.
//

import Foundation
import SOMotionDetector
import SwiftyUserDefaults

class LocationMonitor:NSObject,CLLocationManagerDelegate , MKMapViewDelegate {
    
    var trip : Trip!
    
    
    let locationManager = CLLocationManager()
    var isMoving :Bool! = false
    
    private var isUserStoppedBefore = true
    
    var updateLocationBlock : ((CLLocation,Double)->())!
    let locationPlist = LocationPlistManager()
    
    override init() {
        
        super.init()
        
        //        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        SOLocationManager.sharedInstance().allowsBackgroundLocationUpdates = true
        getMotionDetector().setMaximumRunningSpeed(10)
        if( getMotionDetector().motionType == MotionTypeAutomotive )
        {
            initializeDetection()
            
        }
        checkIfMotionTypeChanegd()
        checkIfLocationChanged()
        startDetection()
        
        
        
    }
    
    
    
    func getMotionDetector()->SOMotionDetector
    {
        return SOMotionDetector.sharedInstance()
    }
    
    func getStepDetector()->SOStepDetector{
        return SOStepDetector.sharedInstance()
    }
    
    func checkIfMotionTypeChanegd()  {
        
        getMotionDetector().motionTypeChangedBlock = { type in
            if SessionObjects.currentVehicle != nil
            {
                if type == MotionTypeAutomotive  && !(Defaults[.isHavingTrip]   ) {
                    
                    // prevent OS from stoping this app tracking after 20 min from being in background mode
                    self.initializeDetection()
                    
                }
                else if type == MotionTypeNotMoving {
                    print("not moving")
                    
                }
            }
        }
    }
    
    private func initializeDetection(){
        SOLocationManager.sharedInstance().locationManager.pausesLocationUpdatesAutomatically = false
        SOLocationManager.sharedInstance().locationManager.activityType = .automotiveNavigation
        
        //update location if location changed by 10 metter to save power
        SOLocationManager.sharedInstance().locationManager.distanceFilter = 10
        
        self.presentStartMotionNotification()
        self.isMoving = true
        self.isUserStoppedBefore = true
    }
    
    func checkIfLocationChanged(){
        
        
        getMotionDetector().locationChangedBlock = { (location) in
            if Defaults[.isHavingTrip] {
                let timeDifference = location?.timestamp.timeIntervalSince(self.locationPlist.readLastLocation().date as Date)
           
                // if location.horizontalAccuracy < 20 {
                //if this is a new trip
                if timeDifference! > (60*10)
                {
                    //                    Defaults[.isHavingTrip] = false
                    self.saveLocation(location: location!)
                }
                else
                {
                    if self.updateLocationBlock != nil
                    {
                        //                        self.updateLocationBlock(Double(location.speed),self.locationPlist.getDistanceInKM())
                        self.updateLocationBlock(location!,self.locationPlist.getDistanceInKM())
                    }
                    
                    if  (timeDifference! > 20 ){
                        print("speed : \(location?.speed)")
                        self.saveLocation(location: location!)
                    }
                        
                    else if location?.speed == 0{
                        
                        print("user stopped")
                        print("distance : \(self.locationPlist.getDistanceInMetter())")
                        if self.isMoving!  {
                            self.presentStopMotionNotification()
                            self.isMoving = false
                        }
                    }
                        
                    else {
                        
                     //   print("irrelevant data ")
                        
                    }
                    
                    
                }
            }
            // }
            
        }
    }
    
    
    func checkIfAccelerationChanged(block : ((CMAcceleration?)->())!){
        
        
        getMotionDetector().accelerationChangedBlock = block
    }
    
    func startDetection(){
        getMotionDetector().startDetection()
    }
    
    
    func stopDetection(){
        stopTrip()
        getMotionDetector().stopDetection()
        
    }
    
    
    func stopTrip(){
        
        isMoving = false
        LocationPlistManager.distance = 0
        // self.saveTrip()
        Defaults[.isHavingTrip] = false
    }
    
    func startNewTrip(){
        locationPlist.clearPlist()
        Defaults[.isHavingTrip] = true
        isMoving = true
        self.isUserStoppedBefore = true
        
        
    }
    
    private func saveLocation(location : CLLocation){
        
        locationPlist.saveLocation(location: location)
        
        //                print(locationPlist.readLastLocation().date)
        locationPlist.saveLastLocationInformation(location: location)
    }
    
    func showStartTripAlert(viewController activeViewCont : UIViewController){
        
        let alert = UIAlertController(title: "Zoba", message: "looks like you are moving  ", preferredStyle: .alert)
        
        let activateAutoReport = UIAlertAction(title: "Auto report", style:.default) { (action) in
            
            print("auto reprt started")
            //            SessionObjects.motionMonitor.startNewTrip()
            
            DispatchQueue.main.async {
                
                if activeViewCont is MotionDetecionMapController{
                    (activeViewCont as! MotionDetecionMapController).clearView()
                }
                else {
                    
                    let story = UIStoryboard.init(name: "MotionDetection", bundle: nil)
                    let controller = story.instantiateViewController(withIdentifier: "autoReporting") as! MotionDetecionMapController
                    
                    activeViewCont.navigationController?.pushViewController(controller, animated: true)
                    
                }
            }
            alert.dismiss(animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(activateAutoReport)
        alert.addAction(cancel)
        
        activeViewCont.present(alert, animated: true, completion: nil)
        
    }
    
    func showStopTripAlert(viewController activeViewCont : UIViewController){
        
        if activeViewCont is MotionDetecionMapController{
            
            //SessionObjects.motionMonitor.stopTrip()
            (activeViewCont as! MotionDetecionMapController).toggleButton()
        }
        else {
            
            
            let alert = UIAlertController(title: "Zoba", message: "you have stopped  ", preferredStyle: .alert)
            
            let stopAutoReport = UIAlertAction(title: "ok", style:.default) { (action) in
                
                let story = UIStoryboard(name: "MotionDetection", bundle: nil)
                let motionDetection = story.instantiateViewController(withIdentifier: "autoReporting") as! MotionDetecionMapController
                activeViewCont.navigationController?.pushViewController(motionDetection, animated: true)
                //SessionObjects.motionMonitor.stopTrip()
                alert.dismiss(animated: true, completion: nil)
            }
            
            let cancel = UIAlertAction(title: "cancel", style:.default) { (action) in
                alert.dismiss(animated: true, completion: nil)
                
                self.presentCheckIfStillMovingNotification()
            }
            
            
            alert.addAction(stopAutoReport)
            alert.addAction(cancel)
            activeViewCont.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func presentStartMotionNotification(){
        
        let notif :UILocalNotification = UILocalNotification()
        notif.alertBody = "looks like you are driving "
        notif.alertTitle = "Zoba"
        notif.category = "zoba_start_motion"
        
        if (UIApplication.shared.applicationState == .background) {
            
            
            
            UIApplication.shared.presentLocalNotificationNow(notif)
        }else {
            
            UIApplication.shared.delegate?.application!(UIApplication.shared, didReceive: notif)
        }
        
    }
    
    func presentStopMotionNotification(){
        
        let notif :UILocalNotification = UILocalNotification()
        notif.alertBody = "looks like you have stopped "
        notif.alertTitle = "Zoba"
        notif.category = "zoba_stop_motion"
        
        
        if (UIApplication.shared.applicationState == .background) {
            
    
            UIApplication.shared.presentLocalNotificationNow(notif)
        }else {
            
            UIApplication.shared.delegate?.application!(UIApplication.shared, didReceive: notif)
        }
        
    }
    
    func presentCheckIfStillMovingNotification(){
        
        let notif :UILocalNotification = UILocalNotification()
        
        notif.alertTitle = "Zoba"
        notif.category = "zoba_check_if_running"
        
        //        let after :Double = 60
        //        if isUserStoppedBefore {
        //            notif.fireDate =  NSDate(timeIntervalSinceNow: after)
        //        print(notif.fireDate)
        //            print("showing notification after \(after)  sec")
        //        }
        //        else{
        //            notif.fireDate =  NSDate(timeIntervalSinceNow: after*3)
        //            print(notif.fireDate)
        //            print("showing notification after \(after*3)  sec")
        //        }
        //        
        
        
        // isUserStoppedBefore = !isUserStoppedBefore
        
        UIApplication.shared.delegate?.application!(UIApplication.shared, didReceive: notif)
    }
    
    
    func checkIfMoving(){
        
        if(!isMoving) {
            if(isUserStoppedBefore){
                print("stopping trip as user still stopped")
                //                stopTrip()
            }
            else{
                print("checking not moving : user still stopped")
                
                Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(LocationMonitor.presentCheckIfStillMovingNotification) , userInfo: nil, repeats: false)
                
                //  presentCheckIfStillMovingNotification()
            }
        }
        else{
            print("checking not moving : user is moving")
        }
    }
    
    
    func getLocation(coordinate : TripCoordinate){
    
        let location = CLLocation(latitude: Double(coordinate.latitude!), longitude: Double(coordinate.longtitude!))
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
             DispatchQueue.main.async {
                if places!.count > 0 {
                    coordinate.address =  places!.first?.name
                    coordinate.save()
                }
            }
            
            
        })
        
    }
    
    
}
