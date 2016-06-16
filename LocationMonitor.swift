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

class LocationMonitor:NSObject,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var delegate : MapDetectionDelegate!
    var updateLocationBlock : ((Double,Double)->())!
    let locationPlist = LocationPlistManager()
    
    init(delegate : MapDetectionDelegate) {
        self.delegate = delegate
        
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        SOLocationManager.sharedInstance().allowsBackgroundLocationUpdates = true
        getMotionDetector().setMaximumRunningSpeed(10)
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
            if type == MotionTypeAutomotive  && !(Defaults[.isHavingTrip]) {
                print("start moving by car show alert ")
                
                // prevent OS from stoping this app tracking after 20 min from being in background mode
                SOLocationManager.sharedInstance().locationManager.pausesLocationUpdatesAutomatically = false
                SOLocationManager.sharedInstance().locationManager.activityType = .AutomotiveNavigation
                
                //update location if location changed by 10 metter to save power
                SOLocationManager.sharedInstance().locationManager.distanceFilter = 10
                self.delegate.showAlert()
            }
        }
    }
    
    func checkIfLocationChanged(){
        
        
        getMotionDetector().locationChangedBlock = { (location) in
            if Defaults[.isHavingTrip] {    
                let timeDifference = location.timestamp.timeIntervalSinceDate(self.locationPlist.readLastLocation().date)
                
                //if this is a new trip
                if timeDifference > (60*10)
                {
                    
                    print("data from old trip from more than 10 minutes earlier")
                    print("time diff \(timeDifference)")
                    self.startNewTrip()
                    self.saveLocation(location)
                    
                    //clear plist and start new trip
                }
                    // interval of updating location in sec
                else if  timeDifference > 2 {
                    print("speed : \(location.speed)")
                    
                    if(location.speed>15){
                        
                        self.saveLocation(location)
                        
                        if self.updateLocationBlock != nil {
                            
                            self.updateLocationBlock(Double(location.speed),self.locationPlist.getDistanceInKM())
                            
                        }
                        
                    }
                    else if location.speed == 0{
                        
                        // user stopped
                        print("user stopped")
                        print("distance : \(self.locationPlist.getDistanceInMetter())")
                        //                    self.getMotionDetector().stopDetection()
                        self.delegate.showStopAlert()
                    }
                    
                }
                    
                else {
                    
                    print("irrelevant data ")
                    
                }
                
            }
        }
    }
    
    func checkIfAccelerationChanged(block : ((CMAcceleration!)->())!){
        
        
        getMotionDetector().accelerationChangedBlock = block
    }
    
    func startDetection(){
        getMotionDetector().startDetection()
    }
    
    
    func stopDetection(){
        getMotionDetector().stopDetection()
    }
    
    
    func stopTrip(){
        Defaults[.isHavingTrip] = false
        
        
        
    }
    
    func startNewTrip(){
        locationPlist.clearPlist()
        Defaults[.isHavingTrip] = true
    }
    
    private func saveLocation(location : CLLocation){
        
        locationPlist.saveLocation(location)
        
        //                print(locationPlist.readLastLocation().date)
        locationPlist.saveLastLocationInformation(location)
    }
}