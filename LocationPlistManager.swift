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
    
    var firstPoint : CLLocationCoordinate2D!
    var secondPoint : CLLocationCoordinate2D!
    
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
            print("saving first location")
            print("\(location.timestamp) \n \(location.coordinate.longitude ) \n \(location.coordinate.latitude)")
            print("==========================")
            saveFirstLocationInformation(location)
            LocationPlistManager.distance = 0
        }
        self.saveLastLocationInformation(location)
        
        //      self.savePoint(location)
        
        
        
        if firstPoint == nil{
            firstPoint = location.coordinate
            self.savePoint(location)
            print("first point is nil and count : \(locationsArray.count)")
        }else if secondPoint == nil {
            secondPoint = location.coordinate
            self.savePoint(location)
            print("second point is nil and count : \(locationsArray.count)")
            
        }else if !isOnTheSameLine(firstPoint,secondPoint: secondPoint,thirdPoint: location.coordinate){
            
            self.removeLastLocation()
            self.savePoint(location)
            firstPoint = location.coordinate
            secondPoint = nil
            print("not on the same line and count : \(locationsArray.count)")
        }
        
        
    }
    
    private func savePoint(location :CLLocation){
        
        
        
        
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString)
        let arr = dict?.mutableArrayValueForKey("Points")
        let point = NSMutableDictionary()
        point.setValue(String(location.coordinate.latitude), forKey: "latitude")
        point.setValue(String(location.coordinate.longitude), forKey: "longitude")
        point.setValue(String(location.speed), forKey: "speed")
        arr?.addObject(point)
        dict?.writeToFile(path.absoluteString, atomically: false)
        
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
        LocationPlistManager.distance = 0
        
        
        firstPoint = nil
        secondPoint = nil
        
    }
    
    private func removeLastLocation(){
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString)
        let arr = dict?.mutableArrayValueForKey("Points")
        let oldLastLocation = getLocationFromDictionary((arr?.lastObject)! as! NSMutableDictionary)
        arr?.removeLastObject()
        let newLastLocation = getLocationFromDictionary((arr?.lastObject)! as! NSMutableDictionary)
        
        dict?.writeToFile(path.absoluteString, atomically: false)
        
        LocationPlistManager.distance -= oldLastLocation.distanceFromLocation(newLastLocation)
        
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
    
    func getSpeed(atIndex : Int)-> Double
    {
        let dictionary = getLocationDictionaryAt(atIndex)
        let speed = dictionary.valueForKey("speed") as! Double
        return speed
    }
    
    func getCoordinatesArray() -> [CLLocationCoordinate2D]{
        var coordinates = [CLLocationCoordinate2D]()
        for i in 0 ..< self.getLocationsDictionaryArray().count {
            let location = self.getLocationFromDictionary(self.getLocationDictionaryAt(i))
            coordinates.append(location.coordinate)
            
        }
        return coordinates
        
    }
    
    func getDistanceInMetter() -> (Double){
        return LocationPlistManager.distance
    }
    
    
    func getDistanceInKM() -> (Double){
        return (LocationPlistManager.distance / 1000)
    }
    
    
    func saveFirstLocationInformation(location : CLLocation){
        let userDefault =  NSUserDefaults.standardUserDefaults()
        
        userDefault.setObject(location.timestamp, forKey: "firstDate")
        userDefault.setObject(location.coordinate.latitude, forKey: "firstLatitude")
        userDefault.setObject(location.coordinate.longitude, forKey: "firstLongitude")
        
    }
    
    func readFirstLocation() -> (date: NSDate! ,latitude: CLLocationDegrees! ,longitude : CLLocationDegrees!){
        
        let userDefault =  NSUserDefaults.standardUserDefaults()
        if ( userDefault.objectForKey("firstDate") != nil){
            let date = userDefault.objectForKey("firstDate") as! NSDate
            
            let latitude = userDefault.objectForKey("firstLatitude") as! CLLocationDegrees
            let longitude = userDefault.objectForKey("firstLongitude") as! CLLocationDegrees
            
            return (date ,latitude ,longitude)
        }
        else {
            
            return (NSDate(timeIntervalSince1970: 0),nil,nil)
        }
    }
    
    
    func saveLastLocationInformation(location : CLLocation){
        let userDefault =  NSUserDefaults.standardUserDefaults()
        
        userDefault.setObject(location.timestamp, forKey: "lastDate")
        userDefault.setObject(location.coordinate.latitude, forKey: "lastLatitude")
        userDefault.setObject(location.coordinate.longitude, forKey: "lastLongitude")
        
    }
    
    func readLastLocation() -> (date: NSDate! ,latitude: CLLocationDegrees! ,longitude : CLLocationDegrees!){
        
        let userDefault =  NSUserDefaults.standardUserDefaults()
        if ( userDefault.objectForKey("lastDate") != nil){
            let date = userDefault.objectForKey("lastDate") as! NSDate
            
            let latitude = userDefault.objectForKey("lastLatitude") as! CLLocationDegrees
            let longitude = userDefault.objectForKey("lastLongitude") as! CLLocationDegrees
            
            return (date ,latitude ,longitude)
        }
        else {
            
            return (NSDate(timeIntervalSince1970: 0),nil,nil)
        }
    }
    
    func removeAllButLastLocation(){
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString)
        let oldArr = dict?.mutableArrayValueForKey("Points")
       
        while oldArr?.count > 1 {
            oldArr?.removeObjectAtIndex(0)
        }
        dict?.writeToFile(path.absoluteString, atomically: false)
    }
}