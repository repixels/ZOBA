//
//  Vehicle.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

class Vehicle: NSManagedObject , Mappable{
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("Vehicle", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        var trackingDataArray : [TrackingData]?
        var tripsArray : [Trip]?
        
        var isAdminFlag = false
        isAdminFlag <- map["adminFlag"]
        
        
        self.currentOdemeter <- map["currentOdemeter"]
        self.initialOdemeter <- map["intialOdemeter"]
        
        if isAdminFlag
        {
            self.isAdmin = 1
        }
        else
        {
            self.isAdmin = 0
        }
        self.vehicleId <- map["id"]
        self.licensePlate <- map["licencePlate"]
        self.name <- map["name"]
        self.vehicleModel <- map["vehicleModel"]
        
        
        
        if map.mappingType == .ToJSON {
            
            var mappedTrips = Mapper().toJSONArray((self.trip!.allObjects as! [Trip]))
            mappedTrips <- map["trips"]
            
            
            
            
            var mappedTrackingData  = Mapper().toJSONArray((self.traclingData?.allObjects as! [TrackingData]))
            
            mappedTrackingData <- map["trackingDatas"]
            
        }
        else {
            
            
            trackingDataArray <- map["trackingDatas"]
            tripsArray <- map["trips"]
            if trackingDataArray != nil
            {
                self.traclingData = NSSet(array: trackingDataArray!)
            }
            else
            {
                self.traclingData = nil
            }
            
            if tripsArray != nil
            {
                self.trip = NSSet(array: tripsArray!)
            }
            else
            {
                self.trip = nil
            }
            
        }
        
        
    }
}
