//
//  LocationPlistManager.swift
//  UserScreen
//
//  Created by me on 5/22/16.
//  Copyright © 2016 Zooba. All rights reserved.
//

import Foundation
import SOMotionDetector

class LocationPlistManager {
    
    var name : String
    var path : NSURL
    static var distance = 0.0
    
    init(){
        
        self.name = "CoordinateList"
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(string: paths)
        path = (url?.URLByAppendingPathComponent(name+".plist"))!
        let fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath((path.absoluteString))))
        {
            do {
                //try fileManager.removeItemAtPath(path!.absoluteString)
                let bundle : NSString = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
                try  fileManager.copyItemAtPath(bundle as String, toPath: path.absoluteString)
            }
                
            catch let error {
                print(error)
            }
        }
        
    }
    
    func saveLocation( location :CLLocation ){
        
        // if plist is empty then this is the first location to save then no distance to calc
        let locationsArray = self.getLocationsDictionaryArray()
        if(locationsArray.count>0){
            let lastLoc = self.getLocationFromDictionary(self.getLocationDictionaryAt(locationsArray.count - 1))
            
            LocationPlistManager.distance += location.distanceFromLocation(lastLoc)
        }else {
            LocationPlistManager.distance = 0
        }
        self.saveLastLocationInformation(location)
        
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString)
        let arr = dict?.mutableArrayValueForKey("Points")
        let point = NSMutableDictionary()
        point.setValue(String(location.coordinate.latitude), forKey: "latitude")
        point.setValue(String(location.coordinate.longitude), forKey: "longitude")
        arr?.addObject(point)
        dict?.writeToFile(path.absoluteString, atomically: false)
    }
    
    func getLocationsDictionaryArray() -> NSArray {
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString)
        let arr = dict?.mutableArrayValueForKey("Points")
        return arr!;
    }
    
    func clearPlist(){
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString)
        let arr = dict?.mutableArrayValueForKey("Points")
        arr?.removeAllObjects()
        dict?.writeToFile(path.absoluteString, atomically: false)
        
        
    }
    
    func getLocationDictionaryAt(index : Int) -> NSMutableDictionary {
        let arr = getLocationsDictionaryArray()
        
        return arr[index] as! NSMutableDictionary
    }
    
    func getLocationFromDictionary(dictionary : NSMutableDictionary ) ->(CLLocation){
        
        
        let lat = CLLocationDegrees.init(dictionary.valueForKey("latitude") as! String)
        let long = CLLocationDegrees.init(dictionary.valueForKey("longitude") as! String)
        let location:CLLocation = CLLocation(latitude: lat!, longitude: long!)
        return location
    }
    
    func getDistanceInMetter() -> (Double){
        return LocationPlistManager.distance
    }
    
    
    func getDistanceInKM() -> (Double){
        return (LocationPlistManager.distance / 1000)
    }
    
    
    func saveLastLocationInformation(location : CLLocation){
        let userDefault =  NSUserDefaults.standardUserDefaults()
        
        userDefault.setObject(location.timestamp, forKey: "date")
        userDefault.setObject(location.coordinate.latitude, forKey: "latitude")
        userDefault.setObject(location.coordinate.longitude, forKey: "longitude")
        
    }
    
    func readLastLocation() -> (date: NSDate! ,latitude: CLLocationDegrees! ,longitude : CLLocationDegrees!){
        let userDefault =  NSUserDefaults.standardUserDefaults()
        if ( userDefault.objectForKey("date") != nil){
            let date = userDefault.objectForKey("date") as! NSDate
            let latitude = userDefault.objectForKey("latitude") as! CLLocationDegrees
            let longitude = userDefault.objectForKey("longitude") as! CLLocationDegrees
            return (date ,latitude ,longitude)
        }
        else {
            
            return (NSDate(timeIntervalSince1970: 0),nil,nil)
        }
    }
}