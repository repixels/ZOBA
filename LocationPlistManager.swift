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
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(string: paths)
        path = (url?.appendingPathComponent(name+".plist"))! as NSURL
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: (path.absoluteString)!)))
        {
            do {
                //try fileManager.removeItemAtPath(path!.absoluteString)
                let bundle : NSString = Bundle.main.path(forResource: name, ofType: "plist")! as NSString
                try  fileManager.copyItem(atPath: bundle as String, toPath: path.absoluteString!)
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
            let lastLoc = self.getLocationFromDictionary(dictionary: self.getLocationDictionaryAt(index: locationsArray.count - 1))
            
            LocationPlistManager.distance += location.distance(from: lastLoc)
        }else {
            print("saving first location")
            print("\(location.timestamp) \n \(location.coordinate.longitude ) \n \(location.coordinate.latitude)")
            print("==========================")
            saveFirstLocationInformation(location: location)
            LocationPlistManager.distance = 0
        }
        self.saveLastLocationInformation(location: location)
        
        //      self.savePoint(location)
        
        
        
        if firstPoint == nil{
            firstPoint = location.coordinate
            self.savePoint(location: location)
            print("first point is nil and count : \(locationsArray.count)")
        }else if secondPoint == nil {
            secondPoint = location.coordinate
            self.savePoint(location: location)
            print("second point is nil and count : \(locationsArray.count)")
            
        }else if !isOnTheSameLine(firstPoint: firstPoint,secondPoint: secondPoint,thirdPoint: location.coordinate){
            
            self.removeLastLocation()
            self.savePoint(location: location)
            firstPoint = location.coordinate
            secondPoint = nil
            print("not on the same line and count : \(locationsArray.count)")
        }
        
        
    }
    
    private func savePoint(location :CLLocation){
        
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString!)
        let arr = dict?.mutableArrayValue(forKey: "Points")
        let point = NSMutableDictionary()
        point.setValue(String(location.coordinate.latitude), forKey: "latitude")
        point.setValue(String(location.coordinate.longitude), forKey: "longitude")
        point.setValue(String(location.speed), forKey: "speed")
        arr?.add(point)
        dict?.write(toFile: path.absoluteString!, atomically: false)
        
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
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString!)
        let arr = dict?.mutableArrayValue(forKey: "Points")
        return arr!;
    }
    
    
    func clearPlist(){
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString!)
        let arr = dict?.mutableArrayValue(forKey: "Points")
        arr?.removeAllObjects()
        dict?.write(toFile: path.absoluteString!, atomically: false)
        LocationPlistManager.distance = 0
        
        
        firstPoint = nil
        secondPoint = nil
        
    }
    
    private func removeLastLocation(){
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString!)
        let arr = dict?.mutableArrayValue(forKey: "Points")
        let oldLastLocation = getLocationFromDictionary(dictionary: (arr?.lastObject)! as! NSMutableDictionary)
        arr?.removeLastObject()
        let newLastLocation = getLocationFromDictionary(dictionary: (arr?.lastObject)! as! NSMutableDictionary)
        
        dict?.write(toFile: path.absoluteString!, atomically: false)
        
        LocationPlistManager.distance -= oldLastLocation.distance(from: newLastLocation)
        
    }
    
    func getLocationDictionaryAt(index : Int) -> NSMutableDictionary {
        let arr = getLocationsDictionaryArray()
        
        return arr[index] as! NSMutableDictionary
    }
    
    func getLocationFromDictionary(dictionary : NSMutableDictionary ) ->(CLLocation){
        
        let lat = CLLocationDegrees.init(dictionary.value(forKey: "latitude") as! String)
        let long = CLLocationDegrees.init(dictionary.value(forKey: "longitude") as! String)
        
        let location:CLLocation = CLLocation(latitude: lat!, longitude: long!)
        
        return location
    }
    
    func getSpeed(atIndex : Int)-> Double
    {
        let dictionary = getLocationDictionaryAt(index: atIndex)
        let speed = dictionary.value(forKey: "speed") as! Double
        return speed
    }
    
    func getCoordinatesArray() -> [CLLocationCoordinate2D]{
        var coordinates = [CLLocationCoordinate2D]()
        for i in 0 ..< self.getLocationsDictionaryArray().count {
            let location = self.getLocationFromDictionary(dictionary: self.getLocationDictionaryAt(index: i))
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
        let userDefault =  UserDefaults.standard
        
        userDefault.set(location.timestamp, forKey: "firstDate")
        userDefault.set(location.coordinate.latitude, forKey: "firstLatitude")
        userDefault.set(location.coordinate.longitude, forKey: "firstLongitude")
        
    }
    
    func readFirstLocation() -> (date: NSDate? ,latitude: CLLocationDegrees? ,longitude : CLLocationDegrees?){
        
        let userDefault =  UserDefaults.standard
        if ( userDefault.object(forKey: "firstDate") != nil){
            let date = userDefault.object(forKey: "firstDate") as! NSDate
            
            let latitude = userDefault.object(forKey: "firstLatitude") as! CLLocationDegrees
            let longitude = userDefault.object(forKey: "firstLongitude") as! CLLocationDegrees
            
            return (date ,latitude ,longitude)
        }
        else {
            
            return (NSDate(timeIntervalSince1970: 0),nil,nil)
        }
    }
    
    
    func saveLastLocationInformation(location : CLLocation){
        let userDefault =  UserDefaults.standard
        
        userDefault.set(location.timestamp, forKey: "lastDate")
        userDefault.set(location.coordinate.latitude, forKey: "lastLatitude")
        userDefault.set(location.coordinate.longitude, forKey: "lastLongitude")
        
    }
    
    func readLastLocation() -> (date: NSDate? ,latitude: CLLocationDegrees? ,longitude : CLLocationDegrees?){
        
        let userDefault =  UserDefaults.standard
        if ( userDefault.object(forKey: "lastDate") != nil){
            let date = userDefault.object(forKey: "lastDate") as! NSDate
            
            let latitude = userDefault.object(forKey: "lastLatitude") as! CLLocationDegrees
            let longitude = userDefault.object(forKey: "lastLongitude") as! CLLocationDegrees
            
            return (date ,latitude ,longitude)
        }
        else {
            
            return (NSDate(timeIntervalSince1970: 0),nil,nil)
        }
    }
    
    func removeAllButLastLocation(){
        let dict = NSMutableDictionary.init(contentsOfFile: path.absoluteString!)
        let oldArr = dict?.mutableArrayValue(forKey: "Points")
       
        while (oldArr?.count)! > 1 {
            oldArr?.removeObject(at: 0)
        }
        dict?.write(toFile: path.absoluteString!, atomically: false)
    }
}
